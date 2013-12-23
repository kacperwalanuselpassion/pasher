class DishManager
  def initialize(user)
    @user = user
  end

  def save(dish_params)
    @dish = Dish.new.storage.mapper.to_object(dish_params)
    @dish.user_uid = @user.uid
    Dish.new.storage.save(@dish)
    @dish
  end

  def remove(dish_id, user_id)
    Dish.new.storage.remove(dish_id) if user_id.eql? @user.uid
  end
end
