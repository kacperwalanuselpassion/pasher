class OrderCreator
  def initialize(user, order_params)
    @user = user
    @order_params = order_params
  end

  def save
    @order = Order.new(@order_params)
    @order.founder_uid = @user.uid
    Storage::Order.save(@order)
    @order
  end
end