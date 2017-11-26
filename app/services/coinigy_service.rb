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
    json = JSON.parse(res.body, symbolize_names: true)
    check_json_response(json)
    json[:data].map { |e| Exchange.from_json(e) }
  end

  def refresh_markets(exchange)
    fetch_markets(exchange).each do |m|
      Market.find_or_create_by(exchange: exchange, code: m.code)
    end
  end

  def fetch_markets(exchange)
    res = http_post('/api/v1/markets', 'exchange_code': exchange.code)
    json = JSON.parse(res.body, symbolize_names: true)
    check_json_response(json)
    json[:data].map { |m| Market.from_json(exchange, m) }
  end

  private

  def http_post(url, body = nil)
    client = HTTPClient.new
    res = client.post("#{BASE_URL}#{url}", body&.to_json, auth_headers)
    raise CoinigyServiceError, "Error while post request: (#{res.status}) #{res.body}" unless res.status == 200
    res
  end

  def check_json_response(json)
    raise CoinigyServiceError, "Coinigy returned error json message: #{json.to_json}" if json.key?(:err_num)
  end

  def auth_headers
    {
      'Content-Type' => 'application/json',
      'X-API-KEY' => 'e60cb433e8e37bf0c9784cf7d1ff7e44',
      'X-API-SECRET' => '4a48a223081f54c3130de7c904305f77'
    }
  end
end
