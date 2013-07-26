class OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Storage::Order.all
    respond_with @orders
  end

  #def new
  #end

  def update
  end

  def create
    @new_order = Order.create(params[:order])
  end

  #def edit
  #end

  def show
    @order = Storage::Order.find(params[:id])
    respond_with @order
  end

  def destroy
  end
end
