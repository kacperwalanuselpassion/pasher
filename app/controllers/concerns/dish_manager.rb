class DishManager
  def initialize(user)
    @user = user
  end

  def save(dish_params)
    @dish = Storage::Mongo::Dish.mapper.to_object(dish_params)
    @dish.user_uid = @user.uid
    Storage::Mongo::Dish.save(@dish)
    @dish
  end

  def remove(dish_id, user_id)
    Storage::Mongo::Dish.remove(dish_id) if user_id.eql? @user.uid
  end
end
