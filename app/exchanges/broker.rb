class Broker
  def self.process(order)
    exchange_api = find_exchange_api(order.market.exchange.code)
    return logger.error("Unsupported exchange #{order.market.exchange.code}") if exchange_api.nil?
    case order.status
    when :requested
      exchange_api.place_order(order)
    when [:pending, :pending_cancel]
      exchange_api.track_order(order)
    when :requested_cancel
      exchange_api.cancel_order(order)
    else
      logger.info("Nothing to do for order #{order.uuid}")
    end
  end

  def self.find_exchange_api(exchange_code)
    case exchange_code
    when 'BINA'
      BinanceExchangeApi.new
    else
      nil
    end
  end

  def self.logger
    Rails.logger
  end
end
