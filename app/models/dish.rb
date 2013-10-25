class Dish
  extend ActiveModel::Naming
  include ActiveModel::SerializerSupport

  attr_accessor :_id, :name, :description, :price, :user_uid, :order_uid

  def initialize(attributes)
    update_attributes(attributes)
  end

  def attributes
    {
        uid: @_id,
        name: @name,
        description: @description,
        price: @price,
        user_uid: @user_uid,
        order_uid: @order_uid
    }
  end

  def update_attributes attributes
    @_id   = attributes['_id'].to_s
    @name = attributes['name']
    @description = attributes['description']
    @price = attributes['price']
    @user_uid = attributes['user_uid'].to_s
    @order_uid = attributes['order_uid'].to_s
  end
end
