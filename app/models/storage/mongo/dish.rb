module Storage::Mongo
  class Dish
    class << self
      def mapper
        Storage::Mongo::Dish::Mapper
      end

      def all
        collection.find().sort(_id: -1).map { |response| mapper.to_object(response) }
      end

      def find(id)
        response = collection.find_one(_id: BSON::ObjectId(id))
        mapper.to_object(response)
      end

      def find_by(key, value)
        collection.find_one(key => value)
      end

      def find_all_by(key, value)
        collection.find(key => value).map { |response| mapper.to_object(response) }
      end

      def save(dish)
        collection.save(mapper.to_storage(dish))
      end

      def update(id, dish)
        collection.update({_id: BSON::ObjectId(id)}, mapper.to_storage(dish))
      end

      def remove(id)
        collection.remove(_id: BSON::ObjectId(id))
      end

      def remove_by_order_uid(order_uid)
        collection.remove(order_uid: order_uid)
      end

      def users(users_ids)
        User.where(uid: users_ids)
      end

      def order(order_id)
        Order.new.storage.find(order_id)
      end

      private

      def collection
        Storage::Mongo::Driver.db['dishes']
      end
    end
  end
end
