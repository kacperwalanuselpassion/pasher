class WelcomeController < ApplicationController
  def index
    redirect_to '/sign_in' and return unless current_user
  end

  def sign_in
  end
end
