module Storage::Mongo
  class BitcoinWallet
    class << self
      def mapper
        Storage::Mongo::BitcoinWallet::Mapper
      end

      def all
        collection.find().sort(_id: -1).map { |response| mapper.to_object(response) }
      end

      def all_by_user(user)
        collection.find(user_uid: user.uid).sort(_id: -1).map { |response| mapper.to_object(response) }
      end

      def find(id)
        response = collection.find_one(_id: BSON::ObjectId(id))
        mapper.to_object(response)
      end

      def record_exists?(user_uid, address)
        !collection.find(user_uid: user_uid, address: address).map{|r| mapper.to_object(r) }.empty?
      end

      def find_by(key, value)
        collection.find_one(key => value)
      end

      def find_all_by(key, value)
        collection.find(key => value).map { |response| mapper.to_object(response) }
      end

      def save(bitcoin_wallet)
        collection.save(mapper.to_storage(bitcoin_wallet))
      end

      def remove(id)
        collection.remove(_id: BSON::ObjectId(id))
      end

      def remove_by_user_uid(user_uid)
        collection.remove(user_uid: user_uid)
      end

      def user(user_id)
        User.find_by_uid(user_id)
      end

      def order(order_id)
        Order.new.storage.find(order_id)
      end

      private

      def collection
        Storage::Mongo::Driver.db['bitcoin_wallets']
      end
    end
  end
end
