class OrderOrderedAtFromStringToDatetime < ActiveRecord::Migration
  def up
    Order.new.all.each do |order|
      ordered_at = order.ordered_at
      if ordered_at.is_a?(String)
        ordered_at = Time.parse(ordered_at).utc
        order.ordered_at = ordered_at
        Order.new.update(order._id, order)
      end
    end
  end
end
