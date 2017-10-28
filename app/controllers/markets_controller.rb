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

  validates :update do
    boolean :subscribed, require: true, strong: true, description: 'Flag indicated whether this is subscribed'
  end
  def update
    market.update_attributes(update_params)
    market.save!
    render :show
  end

  private

  def market
    @market ||= Market.find(params[:id].to_i)
  end

  def update_params
    params = permitted_params
    params
  end
end
