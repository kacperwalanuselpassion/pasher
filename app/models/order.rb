class Order
  include Order::StorageDelegator
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :delivery_cost, :founder_uid, :_id, :ordered_at, :active, :executor, :executor_email, :url,
                :min_order_price, :storage, :bitcoin_wallet

  def initialize
    self.storage = Storage::Mongo::Order
  end

  def dishes
    storage.dishes self._id
  end

  def draw_executor
    sample = dishes.map(&:user).sample
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
