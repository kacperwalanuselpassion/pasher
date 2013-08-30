class OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Storage::Order.all
    respond_with @orders, root: false
  end

  def create
    @order = OrderCreator.new(current_user, params[:order]).save
    respond_with @order
  end

  def update
    @order = Storage::Order.find(params[:id])
    @order.update_attributes(params[:order])

    Storage::Order.update(@order)
    head :no_content
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
