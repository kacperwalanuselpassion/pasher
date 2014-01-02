class OrderSerializer < ActiveModel::Serializer
  self.root = false

  attributes :_id, :name, :ordered_at, :founder, :founder_uid, :active, :delivery_cost,
             :min_order_price, :total_sum, :executor, :url
  has_many :dishes

  def founder
    founder = User.where(uid: object.founder_uid).first
    {
      uid: founder.uid,
      name: founder.name
    }
  end
end
