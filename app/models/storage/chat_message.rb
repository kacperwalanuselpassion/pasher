module Storage
  class ChatMessage
    class << self

      def all(limit = 50)
        skipped = collection.count() - limit
        collection.find().skip(skipped).sort({_id: 1}).map { |response| ::ChatMessage.new(response) }
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
        Storage::Driver::db['chat_messages']
      end
    end
  end
end
