class ChatMessageManager
  def initialize(user)
    @user = user
  end

  def save(chat_message_params)
    @chat_message = ChatMessage.new(chat_message_params)
    @chat_message.sender_uid = @user.uid
    @chat_message.sender_name = @user.name
    Storage::ChatMessage.save(@chat_message)
    @chat_message
  end

  def remove(chat_message_id)
    chat_message = Storage::ChatMessage.find(chat_message_id)
    Storage::ChatMessage.remove(chat_message_id) if chat_message.sender_uid.eql? @user.uid
  end
end
