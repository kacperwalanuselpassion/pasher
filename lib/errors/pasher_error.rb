module Errors
  class PasherError < StandardError

    def to_hash
      { error: {message: self.message} }
    end

  end
end