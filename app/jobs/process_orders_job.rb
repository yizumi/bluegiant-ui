# frozen_string_literal: true

class ProcessOrdersJob
  include ::ScheduledJob

  def display_name
    'orders:process'
  end

  def perform
    logger.info 'Process orders in the database'
    Order.open_orders.each do |order|
      Broker.process(order)
    end
    logger.info 'All orders processed'
  end

  def self.time_to_recur(last_run_at)
    last_run_at.end_of_day + 5.seconds
  end

  def logger
    Rails.logger
  end
end
