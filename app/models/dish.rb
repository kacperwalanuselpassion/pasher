class Dish
  include Dish::StorageDelegator
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :description, :price, :users_uids, :order_uid, :storage, :joinable, :participants_limit

  def initialize
    self.storage = Storage::Mongo::Dish
  end

  def users
    storage.users(self.users_uids)
  end

  def order
    storage.order(self.order_uid)
  end

  def can_join?
    self.joinable && !participants_limit_exceeded?
  end

  def participants_limit_exceeded?
    self.participants_limit && self.participants_limit > self.users_uids.size - 1
  end
end
