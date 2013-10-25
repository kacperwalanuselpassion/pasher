class DishSerializer < ActiveModel::Serializer
  self.root = false

  attributes :_id, :name, :description, :price, :user_name, :user_uid, :order_uid

  def user_name
    object.user.name
  end
end
