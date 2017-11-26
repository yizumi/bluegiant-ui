class TestExchangeApi
  class TestExchangeError < StandardError; end

  def initialize(sleep_length = 2)
    @sleep_length = sleep_length
  end

  def place_order(order)
    sleep sleep_length
    order.update_attributes!(status: :pending, external_order_id: SecureRandom.uuid)
  end

  def track_order(order)
    sleep sleep_length
    case order.status
    when :pending
      order.update_attributes!(status: :executed, remaining_quantity: 0.0)
    when :pending_cancel
      order.update_attributes!(status: :cancelled)
    else
      raise TestExchangeError, "#{order.status} is not supported for track_order"
    end
  end

  def cancel_order(order)
    sleep sleep_length
    order.update_attributes!(status: :pending_cancel)
  end

  private

  def sleep_length
    @sleep_length
  end
end
