class PasherConfig
  CONFIG = {}.tap do |config|

    config[:chat] = {}.tap do |chat|
      chat[:on] = ENV['CHAT_ON'].eql? '1'
      chat[:polling_interval] = ENV['CHAT_POLLING_INTERVAL'].to_i
    end

    config[:orders] = {}.tap do |orders|
      orders[:polling_interval] = ENV['ORDERS_POLLING_INTERVAL'].to_i
    end

  end
end