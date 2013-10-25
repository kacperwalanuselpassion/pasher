class DishManager
  def initialize(user)
    @user = user
  end

  def save(dish_params)
    @dish = Dish.new(dish_params)
    @dish.user_uid = @user.uid
    Storage::Dish.save(@dish)
    @dish
  end

  def remove(dish)
    Storage::Dish.remove(dish) if dish.user_uid.eql? @user.uid
  end
end
