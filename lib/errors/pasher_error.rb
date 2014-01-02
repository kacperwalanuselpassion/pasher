module Errors
  class PasherError < StandardError

    def to_hash
      { message: self.message }
    end

  end
end