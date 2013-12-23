class Dish
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :description, :price, :user_uid, :order_uid, :storage

  def initialize
    self.storage = Storage::Mongo::Dish
  end

  def user
    User.find_by_uid(user_uid)
  end
end
