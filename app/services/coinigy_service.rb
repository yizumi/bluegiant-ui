class CoinigyService
  class CoinigyServiceError < StandardError; end

  def exchanges
    @exchanges ||= fetch_exchanges
  end

  def fetch_exchanges
    res = http_post('https://api.coinigy.com/api/v1/exchanges')
    data = JSON.parse(res.body, {:symbolize_names => true})[:data]
    data.map { |e| Exchange.from_json(e) }
  end

  private

  def http_post(url)
    client = HTTPClient.new
    res = client.post(url, {}, auth_headers)
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
