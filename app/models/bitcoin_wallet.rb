class BitcoinWallet
  include BitcoinWallet::StorageDelegator
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :storage, :address, :user_uid, :user

  def initialize
    self.storage = Storage::Mongo::BitcoinWallet
  end

  def user
    User.find_by_uid(user_uid).first
  end
end
