module Storage::Mongo
  class Order
    class Mapper
      def self.to_object(response)
        order = ::Order.new
        order._id   = response['_id'].to_s
        order.name = response['name']
        order.delivery_cost = response['delivery_cost']
        order.min_order_price = response['min_order_price']
        order.founder_uid = response['founder_uid']
        order.ordered_at = response['ordered_at']
        order.active     = !!response['active']
        order.executor = response['executor']
        order.executor_email = response['executor_email']
        order.url = ::Order.parse_url(response['url'])
        order.bitcoin_wallet = response['bitcoin_wallet']
        order
      end

      def self.to_storage(order)
        {
            name: order.name,
            delivery_cost: order.delivery_cost,
            min_order_price: order.min_order_price,
            founder_uid: order.founder_uid,
            ordered_at: ordered_at(order.ordered_at),
            active: order.active,
            executor: order.executor,
            executor_email: order.executor_email,
            url: order.url,
            bitcoin_wallet: order.bitcoin_wallet
        }
      end

      def self.ordered_at(ordered_at)
        ordered_at.is_a?(String) ? Time.parse(ordered_at).utc : ordered_at
      end
    end
  end
end
