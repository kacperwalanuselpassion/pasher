module Storage::Mongo
  class Order
    class << self
      def mapper
        Storage::Mongo::Order::Mapper
      end
      
      def all
        collection.find().sort({_id: -1}).map { |response| mapper.to_object(response) }
      end

      def last(limit = 5)
        active + last_inactive(limit)
      end

      def find(id)
        response = collection.find_one(_id: BSON::ObjectId(id))

        mapper.to_object(response)
      end

      def save(order)
        collection.save(mapper.to_storage(order))
      end

      def update(id, order)
        collection.update({_id: BSON::ObjectId(id)}, mapper.to_storage(order))
      end

      def remove(id)
        collection.remove(_id: BSON::ObjectId(id))
      end

      def active
        collection.find({active: true}).sort({_id: -1}).map { |response| mapper.to_object(response) }
      end

      def last_inactive(limit)
        collection.find({active: false}).sort({_id: -1}).limit(limit).map { |response| mapper.to_object(response) }
      end

      private

      def collection
        Storage::Mongo::Driver.db['orders']
      end
    end
  end
end
