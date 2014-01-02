class PasherConfig
  class EnvVarNotSetError < StandardError
    def initialize(env_var_name)
      message = "ENV['#{env_var_name}'] has to be set"
      super(message)
    end
  end

  def self.validate_env_var_presence(env_var_name)
    raise EnvVarNotSetError.new(env_var_name) if ENV[env_var_name].blank?
  end

  CONFIG = {}.tap do |config|

    config[:chat] = {}.tap do |chat|
      chat[:on] = ENV['CHAT_ON'].eql? '1'

      validate_env_var_presence('CHAT_POLLING_INTERVAL')
      chat[:polling_interval] = ENV['CHAT_POLLING_INTERVAL'].to_i
    end

    config[:orders] = {}.tap do |orders|
      validate_env_var_presence('ORDERS_POLLING_INTERVAL')
      orders[:polling_interval] = ENV['ORDERS_POLLING_INTERVAL'].to_i
    end

    config[:emails] = {}.tap do |emails|
      validate_env_var_presence('USERS_EMAIL')
      emails[:users] = ENV['USERS_EMAIL']

      validate_env_var_presence('PASHER_EMAIL')
      emails[:pasher] = ENV['PASHER_EMAIL']
    end

  end
end