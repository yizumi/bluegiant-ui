class MarketsController < ApplicationController
  def create
    CoinigyService.new.refresh_markets(exchange)
    redirect_to exchange_path(exchange.code)
  end

  def exchange
    @exchange ||= Exchange.find_by!(code: params[:exchange_id])
  end
end
