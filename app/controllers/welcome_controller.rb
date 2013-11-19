class WelcomeController < ApplicationController
  def index
    @dishes_descriptions = { dishes_descriptions: Storage::Dish.all.map(&:description).compact }.to_json
    redirect_to '/sign_in' and return unless current_user
  end

  def sign_in
  end
end
