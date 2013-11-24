class OrdersController < ApplicationController
  respond_to :json

  def index
    @orders = Order.storage.last
    respond_with @orders, root: false
  end

  def create
    @order = OrderManager.new(current_user).save(params[:order])
    respond_with @order
  end

  def update
    OrderManager.new(current_user).update(params[:id], params[:order])
    head :no_content
  end

  def show
    @order = Order.storage.find(params[:id])
    respond_with @order
  end

  def destroy
    OrderManager.new(current_user).remove(params[:id])
    head :no_content
  end

  def finalize
    if finalized_order = OrderManager.new(current_user).finalize(params[:id])
      render json: {executor: finalized_order.executor}
    else
      render json: {error: 'Eror saving order.'}
    end
  end
end
