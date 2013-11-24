class OrderManager
  def initialize(user)
    @user = user
  end

  def save(order_params)
    order = Storage::Mongo::Order::Mapper.to_object(order_params)
    order.active = true
    order.founder_uid = @user.uid
    Storage::Mongo::Order.save(order)
    OrderMailer.new_order_email(@user, order).deliver
    order
  end

  def update(order_id, order_params)
    order = Storage::Mongo::Order::Mapper.to_object(order_params)
    Storage::Mongo::Order.update(order_id, order)
  end

  def finalize(order_id)
    order = Storage::Mongo::Order.find(order_id)
    order.draw_executor
    order.active = false
    Storage::Mongo::Order.update(order_id, order)
    OrderMailer.executor_email(order.executor_email, order).deliver
    order
  end

  def remove(order_id)
    order = Storage::Mongo::Order.find(order_id)
    Storage::Mongo::Order.remove(order_id) if order.founder_uid.eql? @user.uid
    remove_dishes(order_id)
  end

  protected

  def remove_dishes(order_id)
    Storage::Mongo::Dish.remove_by_order_uid(order_id)
  end
end
