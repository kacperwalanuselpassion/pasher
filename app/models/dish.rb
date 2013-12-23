class Dish
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :description, :price, :user_uid, :order_uid

  def user
    User.find_by_uid(user_uid)
  end
end
