class DishSerializer < ActiveModel::Serializer
  self.root = false

  attributes :_id, :name, :description, :price, :users_names, :users_uids, :order_uid, :joinable, :participants_limit

  def users_names
    object.users.map(&:name)
  end

  def price
    NumberFormatter.new.number_to_pln(object.price)
  end
end
