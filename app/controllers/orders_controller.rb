class OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Storage::Order.all

    respond_with @orders
  end

  def new
  end

  def update
  end

  def create
  end

  def edit
  end

  def show
    @order = Storage::Order.find(params[:id])
  end

  def destroy
  end
end
