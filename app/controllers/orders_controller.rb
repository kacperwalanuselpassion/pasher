class OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Storage::Order.all
    respond_with @orders, root: false
  end

  def create
    @order = Order.new(params[:order])
    Storage::Order.save(@order)

    respond_with @order
  end

  def show
    @order = Storage::Order.find(params[:id])
    respond_with @order
  end

  def destroy
    Storage::Order.remove(params[:id])
    head :no_content
  end
end
