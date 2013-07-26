module Storage
  class Order
    def self.all
      def self.all
        [self.find(1)] * 5
      end

    end

    def self.find id
      ::Order.new({name: 'KFC', delivery_cost: '10', founder: 'fafsf'})
    end
  end
end
