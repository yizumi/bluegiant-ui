class OrdersController < ApplicationController
  validates :create do
    string :exchange_id, required: true, strong: true
    string :market_id, required: true, strong: true
    string :time_in_force, required: true, strong: true, only: Order.time_in_forces.keys
    string :side, required: true, strong: true, only: Order.sides.keys
    string :price_type, required: true, strong: true, only: Order.price_types.keys
    float :price, required: true, strong: true
    float :quantity, required: true, strong: true
  end
  def create
    @order = Order.create(create_params)
    render json: @order, status: :created
  end
  
  private

  def create_params
    params = permitted_params
    params[:market_id] = market.id
    params.delete(:exchange_id)
    params
  end

  def market
    @market ||= Market.where('id = ? or (exchange_id = ? and code = ?)', params[:market_id].to_i, exchange&.id.to_i, params[:market_id]).first
  end

  def exchange
    @exchange ||= Exchange.where('id = ? or code = ?', params[:exchange_id].to_i, params[:exchange_id]).first
  end
end
