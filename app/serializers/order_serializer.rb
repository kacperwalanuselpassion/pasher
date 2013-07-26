class OrderSerializer < ActiveModel::Serializer
  self.root = false


  attributes :_id, :name, :ordered_at, :founder, :dishes
end
