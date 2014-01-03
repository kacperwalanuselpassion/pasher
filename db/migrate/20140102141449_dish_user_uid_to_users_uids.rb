class DishUserUidToUsersUids < ActiveRecord::Migration
  def up
    Dish.new.all.each do |dish|
      id = dish._id
      attributes = Storage::Mongo::Dish::Mapper.to_storage(dish)
      if attributes['users_uids'] && attributes['users_uids'].empty?
        attributes['users_uids'] = []
        if attributes.delete('user_uid')
          attributes['users_uids'] << attributes['user_uid']
        end
      end
      Storage::Mongo::Driver.db['dishes'].update({_id: BSON::ObjectId(id)}, attributes )
    end
  end
end
