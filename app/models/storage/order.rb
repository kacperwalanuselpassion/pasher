module Storage
  class Order
    class << self

      def all
        collection.find().sort({_id: -1}).map { |response| ::Order.new(response) }
      end

      def last(limit = 5)
        active + last_inactive(5)
      end

      def find(id)
        response = collection.find_one(_id: BSON::ObjectId(id))

        ::Order.new(response)
      end

      def save(order)
        collection.save(order.attributes)
      end

      def update(order)
        attributes = order.attributes
        attributes.delete(:_id)
        collection.update({_id: BSON::ObjectId(order._id)}, attributes)
      end

      def remove(id)
        collection.remove(_id: BSON::ObjectId(id))
      end

      private
      def collection
        Storage::Driver.db['orders']
      end

      def active
        collection.find({active: true}).sort({_id: -1}).map { |response| ::Order.new(response) }
      end

      def last_inactive(limit)
        collection.find({active: false}).sort({_id: -1}).limit(limit).map { |response| ::Order.new(response) }
      end
    end
  end
end
