module Errors
  module Api
    class CreateError < PasherError

      def initialize
        message = "Could not create"
        super(message)
      end

    end
  end
end