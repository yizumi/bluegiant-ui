# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class BinanceExchangeApi
  class BinanceError < StandardError; end

  def initialize
    @config = {
      api_key: 'K1zY80pSb14rNRojH9H9MQwWmOiz2VPzYey7UF8GQsGPsbqVNgzPLKiB9vMUhtDU',
      api_secret: 'S00OgIKZdAADJpamR5Xm7uIB4hXUytgCWCr9jyfV9zjLiBk75vIMDjLYb0DiAVj1',
      base_url: 'https://api.binance.com'
    }
    @client = HTTPClient.new
  end

  def configure(config)
    @config = config
  end

  def place_order(order)
    res = @client.post("#{@config[:base_url]}/api/v3/order", header: with_api_key, body: build_order_body(order))
    check_response(res)
    json = JSON.parse(res.body)
    order.update_attributes!(status: :pending, external_order_id: json['orderId'])
  end

  def place_test_order(order)
    res = @client.post("#{@config[:base_url]}/api/v3/order/test", header: with_api_key, body: build_order_body(order))
    check_response(res)
    order.update_attributes!(status: :cancelled, external_order_id: order.uuid)
  end

  def track_order(order)
    res = @client.get("#{@config[:base_url]}/api/v3/order?#{build_order_query(order)}", header: with_api_key)
    check_response(res)
    json = JSON.parse(res.body)
    remaining_quantity = order.quantity - BigDecimal.new(json['executedQty'])
    order.update_attributes!(status: decode_status(json['status']), remaining_quantity: remaining_quantity)
  end

  def cancel_order(order)
    res = @client.delete("#{@config[:base_url]}/api/v3/order?#{build_order_query(order)}", header: with_api_key)
    check_response(res)
    json = JSON.parse(res.body)
    order.update_attributes!(external_order_id: json['orderId'])
  end

  private

  def with_api_key
    {
      'X-MBX-APIKEY' => @config[:api_key]
    }
  end

  def build_order_body(order)
    params = build_order_body_params(order)
    payload = params.map(&:to_param).join('&')
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @config[:api_secret], payload)
    payload + '&' + { 'signature' => signature }.to_param
  end

  # rubocop:disable Style/MethodLength
  def build_order_body_params(order)
    [
      { 'symbol'            => order.market.code.delete('/') },
      { 'side'              => order.side.upcase },
      { 'type'              => encode_price_type(order.price_type) },
      { 'timeInForce'       => encode_time_in_force(order.time_in_force) },
      { 'quantity'          => order.quantity },
      { 'price'             => order.price },
      { 'recvWindow'        => 10_000 },
      { 'newClientOrderId'  => order.uuid },
      { 'timestamp'         => timestamp }
    ]
  end

  def build_order_query(order)
    params = build_order_query_params(order)
    payload = params.map(&:to_param).join('&')
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @config[:api_secret], payload)
    payload + '&' + { 'signature' => signature }.to_param
  end

  def build_order_query_params(order)
    [
      { 'symbol'            => order.market.code.delete('/') },
      { 'orderId'           => order.external_order_id },
      { 'recvWindow'        => 10_000 },
      { 'timestamp'         => timestamp }
    ]
  end

  def encode_price_type(price_type)
    raise BinanceError, "Unsupported price type: '#{price_type}'" unless price_type_map.key?(price_type.to_sym)
    price_type_map[price_type.to_sym]
  end

  def price_type_map
    {
      limit_order: 'LIMIT'
    }
  end

  def encode_time_in_force(tif)
    raise BinanceError, "Unsupported time_in_force: '#{tif}'" unless time_in_force_map.key?(tif.to_sym)
    time_in_force_map[tif.to_sym]
  end

  def time_in_force_map
    {
      good_till_cancel: 'GTC',
      immediate_or_cancel: 'IOC'
    }
  end

  def decode_status(binance_status)
    raise BinanceError, "Unsupported binance_status: '#{binance_status}'" unless status_map.key?(binance_status)
    status_map[binance_status]
  end

  def status_map
    {
      'NEW'               => :pending,
      'PARTIALLY_FILLED'  => :pending,
      'FILLED'            => :executed,
      'CANCELED'          => :cancelled,
      'PENDING_CANCEL'    => :pending_cancel,
      'REJECTED'          => :rejected,
      'EXPIRED'           => :expired
    }
  end

  def check_response(res)
    raise BinanceError, "Failed during API call: (#{res.code}) #{res.body}" unless HTTP::Status.successful?(res.code)
  end

  def timestamp
    (Time.now.utc.to_f * 1000).to_i
  end
end
