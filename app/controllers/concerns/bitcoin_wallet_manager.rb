class BitcoinWalletManager
  def initialize(user)
    @user = user
  end

  def save(wallet_params)
    unless Storage::Mongo::BitcoinWallet.record_exists?(@user.uid, wallet_params["bitcoin_wallet"])
      wallet = BitcoinWallet.new.mapper.to_object(wallet_params)
      wallet.user_uid = @user.uid
      wallet.save(wallet)
      wallet
    end
  end
end
