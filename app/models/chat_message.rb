class ChatMessage
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :text, :sender_name, :sender_uid, :_id, :created_at

  def initialize(attributes)
    update_attributes(attributes)
  end

  def attributes
    {
        text: @text,
        sender_name: @sender_name,
        sender_uid: @sender_uid,
        created_at: @created_at
    }
  end

  def update_attributes attributes
    @_id = attributes['_id'].to_s
    @text = attributes['text']
    @sender_name = attributes['sender_name']
    @sender_uid = attributes['sender_uid']
    @created_at = attributes['created_at']
  end
end
