module Errors
  module Api
    class DestroyError < PasherError

      def initialize
        message = "Could not destroy"
        super(message)
      end

    end
  end
end