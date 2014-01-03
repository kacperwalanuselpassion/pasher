module BitcoinWallet::StorageDelegator
  DELEGATED_METHODS = %w(mapper all all_by_user find find_by find_all_by save remove remove_by_user_uid user order)

  DELEGATED_METHODS.each do |method_name|
    define_method method_name do |*args|
      storage.send method_name, *args
    end
  end
end
