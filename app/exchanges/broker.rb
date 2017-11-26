# frozen_string_literal: true

class Broker
  class BrokerError < StandardError; end

  class << self
    def process(order)
      exchange_api = find_exchange_api(order.market.exchange.code)
      raise BrokerError, "Unsupported exchange #{order.market.exchange.code}" if exchange_api.nil?
      case order.status
      when :requested
        exchange_api.place_order(order)
      when %i[pending pending_cancel]
        exchange_api.track_order(order)
      when :requested_cancel
        exchange_api.cancel_order(order)
      else
        logger "Nothing to do for status #{order.status} (#{order.id})"
      end
    end

    private

    def find_exchange_api(exchange_code)
      exchanges[exchange_code]
    end

    def exchanges
      @@exchanges ||= {
        'BINA' => BinanceExchangeApi.new
      }
    end

    def logger
      Rails.logger
    end
  end
end
