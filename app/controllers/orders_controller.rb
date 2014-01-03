class OrdersController < ApplicationController
  respond_to :json

  rescue_from Errors::PasherError, with: :pasher_error_handler

  def index
    @orders = Order.new.last
    respond_with @orders, root: false
  end

  def create
    @order = OrderManager.new(current_user).save(params[:order])
    remember_bitcoin_wallet if params['bitcoin_wallet_remember']
    respond_with @order
  end

  def update
    OrderManager.new(current_user).update(params[:id], params[:order])
    remember_bitcoin_wallet if params['bitcoin_wallet_remember']
    head :no_content
  end

  def show
    @order = Order.new.find(params[:id])
    respond_with @order
  end

  def destroy
    OrderManager.new(current_user).remove(params[:id])
  end

  def finalize
    if finalized_order = OrderManager.new(current_user).finalize(params[:id])
      render json: {executor: finalized_order.executor}
    else
      render json: {error: 'Eror saving order.'}
    end
  end

  protected

  def remember_bitcoin_wallet
    BitcoinWalletManager.new(current_user).save(params[:bitcoin_wallet])
  end

  def pasher_error_handler(e)
    render json: e, status: 422
  end


end
