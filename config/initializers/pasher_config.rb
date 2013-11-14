class PasherConfig
  CONFIG = {}.tap do |config|

    config[:chat] = {}.tap do |chat|
      chat[:on] = ENV['CHAT_ON'].eql? '1'
      chat[:polling_interval] = ENV['CHAT_POLLING_INTERVAL'].to_i
    end

    config[:orders] = {}.tap do |orders|
      orders[:polling_interval] = ENV['ORDERS_POLLING_INTERVAL'].to_i
    end

    config[:emails] = {}.tap do |emails|
      raise 'env var [USERS_EMAIL] not set' if ENV['USERS_EMAIL'].blank?
      emails[:users] = ENV['USERS_EMAIL']
    end

  end
end