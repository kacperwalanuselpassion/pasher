class DishesController < ApplicationController
  respond_to :json

  #def index
  #  @dishes = Storage::Dish.all
  #  respond_with @dishes, root: false
  #end

  def create
    @dish = DishManager.new(current_user).save(params[:dish])
    respond_with @dish
  end

  def update
    @dish = Storage::Dish.find(params[:id])
    @dish.update_attributes(params[:dish])

    Storage::Dish.update(@dish)
    head :no_content
  end

  #def show
  #  @dish = Storage::Dish.find(params[:id])
  #  respond_with @dish
  #end

  def destroy
    DishManager.new(current_user).remove(Storage::Dish.find(params[:id]))
    head :no_content
  end
end
