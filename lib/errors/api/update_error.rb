module Errors
  module Api
    class UpdateError < PasherError

      def initialize
        message = "Could not update"
        super(message)
      end

    end
  end
end