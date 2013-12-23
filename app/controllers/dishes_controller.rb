class DishesController < ApplicationController
  respond_to :json

  #def index
  #  @dishes = Storage::Mongo::Dish.all
  #  respond_with @dishes, root: false
  #end

  def create
    @dish = DishManager.new(current_user).save(params[:dish])
    respond_with @dish
  end

  def update
    @dish = Dish.new.find(params[:id])
    @dish.update_attributes(params[:dish])

    Dish.new.update(@dish)
    head :no_content
  end

  #def show
  #  @dish = Storage::Mongo::Dish.find(params[:id])
  #  respond_with @dish
  #end

  def destroy
    dish = Dish.new.find(params[:id])
    DishManager.new(current_user).remove(dish._id, dish.user_uid)
    head :no_content
  end
end
