module Storage
  class Order
    class << self

      def all
        collection.find().sort({_id: -1}).map { |response| ::Order.new(response) }
      end

      def find id
        response = collection.find_one(_id: BSON::ObjectId(id))

        ::Order.new(response)
      end

      def save(order)
        collection.save(order.attributes)
      end

      def update(order)
        collection.update({_id: BSON::ObjectId(order._id)}, order.attributes)
      end


      def remove(id)
        collection.remove(_id: BSON::ObjectId(id))
      end

      private
      def collection
        Storage::Driver.db['orders']
      end
    end
  end
end
