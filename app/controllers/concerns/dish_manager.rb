class DishManager
  def initialize(user)
    @user = user
  end

  def save(dish_params)
    @dish = Dish.new.mapper.to_object(dish_params)
    @dish.users_uids = [@user.uid]
    Dish.new.save(@dish)
    @dish
  end

  def update(dish_id, dish_params)
    dish = Dish.new.mapper.to_object(dish_params)
    Dish.new.update(dish_id, dish)
  end

  def remove(dish_id, users_ids)
    if @user.uid.in?(users_ids)
      Dish.new.remove(dish_id)
    else
      raise Errors::Api::UnauthorizedError
    end
  end
end
