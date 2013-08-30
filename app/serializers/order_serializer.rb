class OrderSerializer < ActiveModel::Serializer
  self.root = false


  attributes :_id, :name, :ordered_at, :founder, :founder_uid, :dishes, :delivery_cost, :total_sum

  def founder
    founder = User.where(uid: object.founder_uid).first
    {
      uid: founder.uid,
      name: founder.name
    }
  end

  def total_sum
    dishes.map{|d| d['price'] || 0}.sum + (object.delivery_cost || 0)
  end
end
