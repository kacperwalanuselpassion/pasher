module Errors
  module Api
    class UnauthorizedError < PasherError

      def initialize
        message = "You're not authorized to execute this action"
        super(message)
      end

    end
  end
end