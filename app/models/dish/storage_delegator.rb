module Dish::StorageDelegator
  DELEGATED_METHODS = %w(mapper all find find_by find_all_by save update remove remove_by_order_uid)

  DELEGATED_METHODS.each do |method_name|
    define_method method_name do |*args|
      storage.send method_name, *args
    end
  end
end