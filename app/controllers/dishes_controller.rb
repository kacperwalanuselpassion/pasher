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
    @dish = Storage::Mongo::Dish.find(params[:id])
    @dish.update_attributes(params[:dish])

    Storage::Mongo::Dish.update(@dish)
    head :no_content
  end

  #def show
  #  @dish = Storage::Mongo::Dish.find(params[:id])
  #  respond_with @dish
  #end

  def destroy
    DishManager.new(current_user).remove(Storage::Mongo::Dish.find(params[:id]))
    head :no_content
  end
end
