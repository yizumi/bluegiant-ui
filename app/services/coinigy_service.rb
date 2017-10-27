# frozen_string_literal: true

class CoinigyService
  class CoinigyServiceError < StandardError; end

  BASE_URL = 'https://api.coinigy.com'

  def refresh_exchanges
    fetch_exchanges.each do |e|
      Exchange.find_or_create_by(code: e.code).update_attributes(e.attributes.except('id', 'created_at', 'updated_at'))
    end
  end

  def fetch_exchanges
    res = http_post('/api/v1/exchanges')
    data = JSON.parse(res.body, symbolize_names: true)[:data]
    data.map { |e| Exchange.from_json(e) }
  end

  def refresh_markets(exchange)
    fetch_markets(exchange).each do |m|
      Market.find_or_create_by(exchange: exchange, code: m.code)
    end
  end

  def fetch_markets(exchange)
    res = http_post('/api/v1/markets', 'exchange_code': exchange.code)
    data = JSON.parse(res.body, symbolize_names: true)[:data]
    data.map { |m| Market.from_json(exchange, m) }
  end

  def refresh_orders(market)
    ActiveRecord::Base.transaction do
      Order.where(market_id: market.id).delete_all
      fetch_orders(market).each(&:save!)
    end
  end

  def fetch_orders(market)
    res = http_post('/api/v1/data', exchange_code: market.exchange.code,
                                    exchange_market: market.code,
                                    type: 'orders')
    data = JSON.parse(res.body, symbolize_names: true)[:data]
    asks = data[:asks]&.map { |o| Order.from_json(market, :ask, o) }
    bids = data[:bids]&.map { |o| Order.from_json(market, :bid, o) }
    (asks || []) + (bids || [])
  end

  private

  def http_post(url, body = nil)
    client = HTTPClient.new
    res = client.post("#{BASE_URL}#{url}", body&.to_json, auth_headers)
    raise StandardError unless res.status == 200
    res
  end

  def auth_headers
    {
      'Content-Type' => 'application/json',
      'X-API-KEY' => 'cca9053c13ee18875d1e66244d3660a4',
      'X-API-SECRET' => '781bea8281b85a7e63fbb9d83aea7bcf'
    }
  end
end
