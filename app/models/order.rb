class Order

  attr_accessor :name, :delivery_cost, :founder

  def initialize(attributes)
    @name = attributes[:name]
    @delivery_cost = attributes[:delivery_cost]
    @founder = attributes[:founder]
  end

  def self.find(conditions = {})
    Order.new({name: 'KFC', delivery_cost: '10', founder: 'fafsf'})
  end

  def self.all
    [self.find] * 5
  end
end