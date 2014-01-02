class OrdersController < ApplicationController
  respond_to :json

  rescue_from Errors::PasherError, with: :pasher_error_handler

  def index
    @orders = Order.new.last
    respond_with @orders, root: false
  end

  def create
    @order = OrderManager.new(current_user).save(params[:order]) rescue raise(Errors::Api::CreateError.new)
    respond_with @order
  end

  def update
    OrderManager.new(current_user).update(params[:id], params[:order]) rescue raise(Errors::Api::UpdateError.new)
    head :no_content
  end

  def show
    @order = Order.new.find(params[:id])
    respond_with @order
  end

  def destroy
    OrderManager.new(current_user).remove(params[:id]) rescue raise(Errors::Api::DestroyError.new)
  end

  def finalize
    if finalized_order = OrderManager.new(current_user).finalize(params[:id])
      render json: {executor: finalized_order.executor}
    else
      render json: {error: 'Eror saving order.'}
    end
  end

  protected

  def pasher_error_handler(e)
    render json: e
  end


end
