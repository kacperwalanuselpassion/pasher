class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  helper_method :current_user, :pasher_config

  def pasher_config
    {}.tap do |config|
      config[:chat] = {}.tap do |chat_config|
        chat_config[:on] = ENV['CHAT_ON']
      end
    end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
