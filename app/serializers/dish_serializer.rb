class DishSerializer < ActiveModel::Serializer
  self.root = false

  attributes :_id, :name, :description, :price, :users_names, :users_uids, :order_uid

  def users_names
    object.users.map(&:name).join(', ')
  end
end
