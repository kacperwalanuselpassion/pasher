module Storage::Mongo
  class BitcoinWallet
    class Mapper
      def self.to_object(response)
        dish = ::BitcoinWallet.new
        dish.address = response['address']
        dish
      end

      def self.to_storage(bitcoin_wallet)
        {
            address: bitcoin_wallet.address,
            user_uid: bitcoin_wallet.user_uid
        }
      end
    end
  end
end
