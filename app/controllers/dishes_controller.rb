class DishesController < ApplicationController
  respond_to :json

  rescue_from Errors::PasherError, with: :pasher_error_handler

  #def index
  #  @dishes = Storage::Mongo::Dish.all
  #  respond_with @dishes, root: false
  #end

  def create
    @dish = DishManager.new(current_user).save(params[:dish]) rescue raise(Errors::Api::CreateError.new)
    respond_with @dish
  end

  def update
    DishManager.new(current_user).update(params[:id], params[:dish]) rescue raise(Errors::Api::UpdateError.new)
    head :no_content
  end

  #def show
  #  @dish = Storage::Mongo::Dish.find(params[:id])
  #  respond_with @dish
  #end

  def destroy
    dish = Dish.new.find(params[:id])
    DishManager.new(current_user).remove(dish._id, dish.users_uids) rescue raise(Errors::Api::DestroyError.new)
    head :no_content
  end

  def join
    dish = Dish.new.find(params[:id])
    DishManager.new(current_user).join(dish)
    head :no_content
  end

  protected

  def pasher_error_handler(e)
    render json: e
  end

end
