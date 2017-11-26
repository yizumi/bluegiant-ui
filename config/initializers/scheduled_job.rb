# frozen_string_literal: true

ScheduledJob.configure do |config|
  config.logger = Rails.logger
end

# Add jobs to execute
ProcessOrdersJob.schedule_job
