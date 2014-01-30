module PriceSerializerHelper
  def self.included(base)
    base.class_eval do
      extend PriceSerializerHelper::ClassMethods
    end
  end

  module ClassMethods
    def to_pln *price_method_names
      price_method_names.each do |price_method_name|
        new_method_name = "#{price_method_name}_to_pln".to_sym
        attributes new_method_name
        define_method new_method_name do
          NumberFormatter.new.number_to_pln(send price_method_name)
        end
      end
    end
  end
end