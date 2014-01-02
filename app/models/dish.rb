class Dish
  include Dish::StorageDelegator
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :description, :price, :users_uids, :order_uid, :storage

  def initialize
    self.storage = Storage::Mongo::Dish
  end

  def users
    [storage.user(self.users_uids)]
  end

  def order
    storage.order(self.order_uid)
  end

end
