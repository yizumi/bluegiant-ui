# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BluegiantUi
  class Application < Rails::Application
    config.load_defaults 5.1
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end

if ENV.key?('BLUEGIANT_SENTRY_DSN')
  Raven.configure do |config|
    config.dsn = ENV['BLUEGIANT_SENTRY_DSN']
  end
end
