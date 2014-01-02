class DishManager
  def initialize(user)
    @user = user
  end

  def save(dish_params)
    @dish = Dish.new.mapper.to_object(dish_params)
    @dish.user_uid = @user.uid
    Dish.new.save(@dish)
    @dish
  end

  def update(dish_id, dish_params)
    dish = Dish.new.mapper.to_object(dish_params)
    Dish.new.update(dish_id, dish)
  end

  def remove(dish_id, user_id)
    Dish.new.remove(dish_id) if user_id.eql? @user.uid
  end
end
