module Errors
  module Api
    class NotAuthorizedError < PasherError

      def initialize
        message = "You are not authorized"
        super(message)
      end

    end
  end
end