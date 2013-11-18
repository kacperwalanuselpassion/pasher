class ChatMessageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :text, :sender_name, :sender_uid, :_id, :timestamp, :sender_avatar

  def timestamp
    return '' unless object.created_at

    minutes_ago = ((Time.now.utc - object.created_at) / 60).to_i
    if minutes_ago < 1
      "just now"
    elsif minutes_ago < 60
      "#{minutes_ago} min ago"
    elsif minutes_ago < 60 * 24
      "#{minutes_ago / 60} hours ago"
    else
      "#{minutes_ago / 60 / 24} days ago"
    end
  end

  def sender_avatar
    User.find_by_uid(sender_uid).gravatar_url
  end
end
