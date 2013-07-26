class OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Storage::Order.all
    respond_with @orders, root: false
  end

  def new
  end

  def update
  end

  def create
    @order = Order.new(params[:order])
    Storage::Order.save(@order)

    respond_with @order
  end

  #def edit
  #end

  def show
    @order = Storage::Order.find(params[:id])
    respond_with @order
  end

  def destroy
    @order = Storage::Order.find(params[:id])
    Storage::Order.remove(@order)
  end
end
