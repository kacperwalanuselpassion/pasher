class OrderManager
  def initialize(user)
    @user = user
  end

  def save(order_params)
    order = Order.new(order_params)
    order.active = true
    order.founder_uid = @user.uid
    Storage::Order.save(order)
    order
  end

  def finalize(order_id)
    order = Storage::Order.find(order_id)
    order.executor = Order.new(order.attributes).executor
    order.active = false
    Storage::Order.update(order)
    order
  end

  def remove(order_id)
    order = Storage::Order.find(order_id)
    Storage::Order.remove(order_id) if order.founder_uid.eql? @user.uid
    remove_dishes(order_id)
  end

  protected

  def remove_dishes(order_id)
    Storage::Dish.remove_by_order_uid(order_id)
  end
end
