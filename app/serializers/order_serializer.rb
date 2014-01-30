class OrderSerializer < ActiveModel::Serializer
  self.root = false

  attributes :_id, :name, :ordered_at, :ordered_at_int, :founder, :founder_uid, :active, :delivery_cost,
             :min_order_price, :total_sum, :executor, :url, :user_delivery_cost, :bitcoin_wallet
  has_many :dishes

  def founder
    founder = User.where(uid: object.founder_uid).first
    {
      uid: founder.uid,
      name: founder.name
    }
  end

  def delivery_cost
    NumberFormatter.new.number_to_pln(object.delivery_cost)
  end

  def user_delivery_cost
    NumberFormatter.new.number_to_pln(object.user_delivery_cost)
  end

  def ordered_at_int
    ordered_at = object.ordered_at
    TimeUtils.to_timestamp(object.ordered_at) if TimeUtils.now < ordered_at
  end

  def total_sum
    NumberFormatter.new.number_to_pln(object.total_sum)
  end

  def min_order_price
    NumberFormatter.new.number_to_pln(object.min_order_price)
  end
end
