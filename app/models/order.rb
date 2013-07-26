class Order
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :name, :delivery_cost, :founder, :_id, :ordered_at
  attr_accessor :dishes

  def initialize(attributes)
    update_attributes(attributes)
  end

  def attributes
    {
      name: @name,
      delivery_cost: @delivery_cost,
      founder: @founder,
      dishes: @dishes,
      dishes: @dishes,
      ordered_at: @ordered_at,
      active: @active
    }
  end

  def update_attributes attributes
    @_id   = attributes['_id'].to_s
    @name = attributes['name']
    @delivery_cost = attributes['delivery_cost']
    @founder = attributes['founder']
    @dishes = attributes['dishes'] || []
    @ordered_at = attributes['ordered_at']
    @active     = !!attributes['active']
  end

  def add_dish(dish)
    dishes << dish
  end
end
