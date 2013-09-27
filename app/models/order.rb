class Order
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :name, :delivery_cost, :founder_uid, :_id, :ordered_at, :active, :executor, :url
  attr_accessor :dishes

  def initialize(attributes)
    update_attributes(attributes)
  end

  def attributes
    {
      name: @name,
      delivery_cost: @delivery_cost,
      founder_uid: @founder_uid,
      dishes: @dishes,
      dishes: @dishes,
      ordered_at: @ordered_at,
      active: @active,
      executor: @executor,
      url: url
    }
  end

  def update_attributes attributes
    @_id   = attributes['_id'].to_s
    @name = attributes['name']
    @delivery_cost = attributes['delivery_cost']
    @founder_uid = attributes['founder_uid']
    @dishes = attributes['dishes'] || []
    @ordered_at = attributes['ordered_at']
    @active     = !!attributes['active']
    @executor = attributes['executor']
    @url = parse_url(attributes['url'])
  end

  def add_dish(dish)
    dishes << dish
  end

  def parse_url(url)
    if url.nil? || url[/:\/\//]
      url
    else
      'http://' + url
    end
  end
end
