class DishSerializer < ActiveModel::Serializer
  include PriceSerializerHelper

  self.root = false

  attributes :_id, :name, :description, :price, :users_names, :users_uids, :order_uid, :joinable, :participants_limit
  to_pln :price

  def users_names
    object.users.map(&:name)
  end
end
