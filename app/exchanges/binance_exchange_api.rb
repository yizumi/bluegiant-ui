# frozen_string_literal: true

class BinanceExchangeApi
  class BinanceError < StandardError; end

  @@config = {
    api_key: 'K1zY80pSb14rNRojH9H9MQwWmOiz2VPzYey7UF8GQsGPsbqVNgzPLKiB9vMUhtDU',
    api_secret: 'S00OgIKZdAADJpamR5Xm7uIB4hXUytgCWCr9jyfV9zjLiBk75vIMDjLYb0DiAVj1',
    base_url: 'https://api.binance.com'
  }

  def self.configure(config)
    @@config = config
  end

  def place_order(order)
    client = HTTPClient.new
    res = client.post("#{@@config[:base_url]}/api/v3/order", header: with_api_key, body: build_order_body(order))
    if HTTP::Status.successful?(res.code)
      json = JSON.parse(res.body)
      order.update_attributes!(
        status: :pending,
        external_order_id: json['orderId']
      )
    else
      raise BinanceError, "Failed to place order: (#{res.code}) #{res.body}"
    end
  end

  def place_test_order(order)
    client = HTTPClient.new
    res = client.post("#{@@config[:base_url]}/api/v3/order/test", header: with_api_key, body: build_order_body(order))
    if HTTP::Status.successful?(res.code)
      json = JSON.parse(res.body)
      order.update_attributes!(
        status: :cancelled,
        external_order_id: order.uuid
      )
    else
      raise BinanceError, "Failed to place order: (#{res.code}) #{res.body}"
    end
  end

  def track_order(order)
    client = HTTPClient.new
    res = client.get("#{@@config[:base_url]}/api/v3/order?#{build_order_query(order)}", header: with_api_key)
    if HTTP::Status.successful?(res.code)
      json = JSON.parse(res.body)
      order.update_attributes!(
        status: decode_status(json['status']),
        remaining_quantity: order.quantity - BigDecimal.new(json['executedQty'])
      )
    else
      raise BinanceError, "Failed to track order: (#{res.code}) #{res.body}"
    end
  end

  def cancel_order(order)
    client = HTTPClient.new
    res = client.delete("#{@@config[:base_url]}/api/v3/order?#{build_order_query(order)}", header: with_api_key)
    if HTTP::Status.successful?(res.code)
      json = JSON.parse(res.body)
      order.update_attributes!(external_order_id: json['orderId'])
    else
      raise BinanceError, "Failed to cancel order: (#{res.code}) #{res.body}"
    end
  end

  private

  def with_api_key
    {
      'X-MBX-APIKEY' => @@config[:api_key]
    }
  end

  def build_order_body(order)
    params = [
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
    payload = params.map(&:to_param).join('&')
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @@config[:api_secret], payload)
    payload + '&' + { 'signature' => signature }.to_param
  end

  def build_order_query(order)
    params = [
      { 'symbol'            => order.market.code.delete('/') },
      { 'orderId'           => order.external_order_id },
      { 'recvWindow'        => 10_000 },
      { 'timestamp'         => timestamp }
    ]
    payload = params.map(&:to_param).join('&')
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @@config[:api_secret], payload)
    payload + '&' + { 'signature' => signature }.to_param
  end

  def encode_price_type(price_type)
    case price_type.to_sym
    when :limit_order
      'LIMIT'
    else
      raise BinanceError, "Unsupported price type: '#{price_type}'"
    end
  end

  def encode_time_in_force(tif)
    case tif.to_sym
    when :good_till_cancel
      'GTC'
    when :immediate_or_cancel
      'IOC'
    else
      raise BinanceError, "Unsupported time_in_force: '#{tif}'"
    end
  end

  def decode_status(binance_status)
    case binance_status
    when 'NEW'
      :pending
    when 'PARTIALLY_FILLED'
      :pending
    when 'FILLED'
      :executed
    when 'CANCELED'
      :cancelled
    when 'PENDING_CANCEL'
      :pending_cancel
    when 'REJECTED'
      :rejected
    when 'EXPIRED'
      :expired
    else
      raise BinanceError, "Unsupported binance_status: '#{binance_status}'"
    end
  end

  def timestamp
    (DateTime.now.utc.to_f * 1000).to_i
  end
end
