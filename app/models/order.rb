class Order
  include Order::StorageDelegator
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :delivery_cost, :founder_uid, :_id, :ordered_at, :active, :executor, :executor_email, :url,
                :min_order_price, :storage

  def initialize
    self.storage = Storage::Mongo::Order
  end

  def dishes
    storage.dishes self._id
  end

  def users
    dishes.flat_map(&:users).uniq
  end

  def user_delivery_cost
    return Float::NAN if !self.delivery_cost || users.count == 0
    self.delivery_cost / users.count
  end

  def draw_executor
    sample = dishes.map(&:users).sample
    self.executor = sample.name
    self.executor_email = sample.email
  end

  def total_sum
    return if dishes.nil?
    dishes.map{ |dish| dish.price || 0 }.sum + (delivery_cost || 0)
  end

  def self.parse_url(url)
    if url.nil? || url[/:\/\//]
      url
    else
      'http://' + url
    end
  end
end