class Order
  attr_accessor :name, :delivery_cost, :founder, :id
  attr_accessor :dishes

  def initialize(attributes)
    @name = attributes[:name]
    @delivery_cost = attributes[:delivery_cost]
    @founder = attributes[:founder]
    @dishes = attributes[:dishes] || []

    @ordered_at = attributes[:ordered_at]
    @active     = !!attributes[:active]
  end

  def attributes
    {
      name: @name,
      delivery_cost: @delivery_cost,
      founder: @founder,
      dishes: @dishes
    }
  end

  def add_dish(dish)
    dishes << dish
  end
end
