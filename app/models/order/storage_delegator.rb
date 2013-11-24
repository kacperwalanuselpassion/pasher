module Order::StorageDelegator
  DELEGATED_METHODS = %w(mapper all last find save update remove active last_inactive)

  def storage
    Storage::Mongo::Order
  end

  DELEGATED_METHODS.each do |method_name|
    define_method method_name do |*args|
      storage.send method_name, *args
    end
  end
end