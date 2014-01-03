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

  def users
    dishes.flat_map(&:users).uniq
  end

  def add_bitcoin_address_url
    (ENV['ROOT_URL'] || '') + "#/add_bitcoin_address/#{self._id}"
  end

  def user_delivery_cost
    return Float::NAN if !self.delivery_cost || users.count == 0
    self.delivery_cost / users.count
  end

  def draw_executor
    drawn_user = users.sample
    self.executor = drawn_user.name
    self.founder_uid = drawn_user.uid
    self.executor_email = drawn_user.email
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
