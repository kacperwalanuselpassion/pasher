module Storage::Mongo
  class Dish
    class Mapper
      def self.to_object(response)
        dish = ::Dish.new
        dish._id   = response['_id'].to_s
        dish.name = response['name']
        dish.description = response['description']
        dish.price = response['price']
        dish.user_uid = response['user_uid']
        dish.order_uid = response['order_uid']
        dish
      end

      def self.to_storage(dish)
        {
            name: dish.name,
            description: dish.description,
            price: dish.price,
            user_uid: dish.user_uid,
            order_uid: dish.order_uid
        }
      end
    end
  end
end