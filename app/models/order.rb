class Order
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :name, :delivery_cost, :founder_uid, :_id, :ordered_at, :active, :executor, :url,
                :min_order_price

  def initialize(attributes)
    update_attributes(attributes)
  end

  def attributes
    {
      name: @name,
      delivery_cost: @delivery_cost,
      min_order_price: @min_order_price,
      founder_uid: @founder_uid,
      ordered_at: @ordered_at,
      active: @active,
      executor: @executor,
      url: @url
    }
  end

  def dishes
    Storage::Dish.find_all_by :order_uid, _id
  end

  def update_attributes attributes
    @_id   = attributes['_id'].to_s
    @name = attributes['name']
    @delivery_cost = attributes['delivery_cost']
    @min_order_price = attributes['min_order_price']
    @founder_uid = attributes['founder_uid']
    @ordered_at = attributes['ordered_at']
    @active     = !!attributes['active']
    @executor = attributes['executor']
    @url = parse_url(attributes['url'])
  end

  protected

  def parse_url(url)
    if url.nil? || url[/:\/\//]
      url
    else
      'http://' + url
    end
  end
end
