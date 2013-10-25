class ChatMessageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :text, :sender_name, :sender_uid, :_id, :timestamp

  def timestamp
    minutes_ago = ((Time.now.utc - object.created_at) / 60).to_i rescue ''
    if minutes_ago < 60
      "#{minutes_ago} min ago"
    elsif minutes_ago < 60 * 24
      "#{minutes_ago / 60} hours ago"
    else
      "#{minutes_ago / 60 / 24} days ago"
    end
  end
end
