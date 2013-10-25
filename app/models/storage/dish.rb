module Storage
  class Dish
    class << self
      def all
        collection.find().sort(_id: -1).map { |response| ::Dish.new(response) }
      end

      def find(id)
        response = collection.find_one(_id: BSON::ObjectId(id))
        ::Dish.new(response)
      end

      def find_by(key, value)
        collection.find_one(key => value)
      end

      def find_all_by(key, value)
        collection.find(key => value).map { |response| ::Dish.new(response) }
      end

      def save(dish)
        collection.save(dish.attributes)
      end

      def update(dish)
        collection.update({_id: BSON::ObjectId(dish._id)}, dish.attributes)
      end

      def remove(dish)
        collection.remove(_id: BSON::ObjectId(dish.attributes[:uid]))
      end

      private

      def collection
        Storage::Driver.db['dishes']
      end
    end
  end
end
