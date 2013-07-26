module Storage
  class Order
    class << self

      def all
        collection.find().sort({_id: -1}).map {|response|  ::Order.new(response)}
      end

      def find id
        response = collection.find_one(id: id)

        ::Order.new(response)
      end

      def save(order)
        collection.save(order.attributes)
      end


      private
      def collection
        driver.db['orders']
      end

      def driver
        Mongo::MongoClient.from_uri ENV['MONGOHQ_URL']
      end
    end
  end
end
