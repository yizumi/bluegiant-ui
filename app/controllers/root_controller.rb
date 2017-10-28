# frozen_string_literal: true

class RootController < ApplicationController
  def index
    @markets = Market.includes(:exchange).where(subscribed: true)
    @api_key = ENV['BLUEGIANT_COINIGY_API_KEY']
    @api_secret = ENV['BLUEGIANT_COINIGY_API_SECRET']
  end
end
