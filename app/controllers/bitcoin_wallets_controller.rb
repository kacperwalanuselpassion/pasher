class BitcoinWalletsController < ApplicationController
  respond_to :json, :html, :svg

  def show
    @order = Order.new.find(params[:id])
    @wallet = @order.bitcoin_wallet['address']
    respond_to do |format|
      format.html
      format.svg  { render qrcode: @wallet, level: :h, unit: 6, offset: 10 }
    end
  end
end
