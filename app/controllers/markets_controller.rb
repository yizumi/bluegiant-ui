# frozen_string_literal: true

class MarketsController < ApplicationController
  def create
    CoinigyService.new.refresh_markets(exchange)
    redirect_to exchange_path(exchange.code)
  end

  def exchange
    @exchange ||= Exchange.find_by!(code: params[:exchange_id])
  end

  def show
    not_found if market.nil?
    render :show
  end

  private

  def market
    @market ||= Market.find_by(params[:code])
  end
end
