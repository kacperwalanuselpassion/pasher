module Errors
  module Api
    module Dish
      class ParticipantsLimitExceeded < PasherError

        def initialize
          message = "Participants limit exceeded"
          super(message)
        end

      end
    end
  end
end