class Order

  attr_accessor :name, :delivery_cost, :founder

  def initialize(attributes)
    @name = attributes[:name]
    @delivery_cost = attributes[:delivery_cost]
    @founder = attributes[:founder]
  end
end