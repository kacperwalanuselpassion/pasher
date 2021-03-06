module Storage::Mongo
  class ChatMessage
    class << self

      def all
        collection.find().sort({_id: -1}).map { |response| ::ChatMessage.new(response) }
      end

      def last(limit = 50)
        collection.find().sort({_id: -1}).limit(limit).map { |response| ::ChatMessage.new(response) }
      end

      def save(chat_message)
        collection.save(chat_message.attributes)
      end

      def update(chat_message)
        collection.update({_id: BSON::ObjectId(chat_message._id)}, chat_message.attributes)
      end

      def remove(id)
        collection.remove(_id: BSON::ObjectId(id))
      end

      private
      def collection
        Storage::Mongo::Driver::db['chat_messages']
      end
    end
  end
end
