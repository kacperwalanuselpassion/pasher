class OrderManager
  def initialize(user)
    @user = user
  end

  def save(order_params)
    @order = Order.new(order_params)
    @order.founder_uid = @user.uid
    Storage::Order.save(@order)
    @order
  end

  def remove(order_id)
    order = Storage::Order.find(order_id)
    Storage::Order.remove(order_id) if order.founder_uid.eql? @user.uid
  end
end