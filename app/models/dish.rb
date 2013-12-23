class Dish
  include Dish::StorageDelegator
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :description, :price, :user_uid, :order_uid, :storage

  def initialize
    self.storage = Storage::Mongo::Dish
  end

  def user
    storage.user(self.user_uid)
  end
end
