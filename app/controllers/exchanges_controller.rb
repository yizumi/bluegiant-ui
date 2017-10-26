# frozen_string_literal: true

class ExchangesController < ApplicationController
  def index
    @exchanges = Exchange.all
  end

  def create
    @exchanges = CoinigyService.new.refresh_exchanges
    redirect_to exchanges_path
  end
end
