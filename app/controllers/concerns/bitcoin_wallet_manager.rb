class BitcoinWalletManager
  def initialize(user)
    @user = user
  end

  def save(wallet_params)
    if validate?(wallet_params)
      wallet = BitcoinWallet.new.mapper.to_object(wallet_params)
      wallet.user_uid = @user.uid
      wallet.save(wallet)
      wallet
    end
  end

  protected

  def validate?(wallet_params)
    wallet_params["address"].present? && wallet_params["address"].length == 34 &&
      !Storage::Mongo::BitcoinWallet.record_exists?(@user.uid, wallet_params["address"])
  end
end
