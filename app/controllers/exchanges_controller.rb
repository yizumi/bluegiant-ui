class ExchangesController < ApplicationController
  def index
    @exchanges = CoinigyService.new.exchanges
  end
end
