class User::UserFinderService
  attr_accessor :strategy
  delegate :find, to: :strategy

  def initialize
    @strategy = Strategy.new
  end

  class Strategy
    def find
      raise NotImplementedError
    end

    class Strategy::GoogleAuthRequest < Strategy
      def initialize(auth_request_data)
        @auth = auth_request_data
      end

      def find
        User.where(provider: @auth['provider'], uid: @auth['uid']).first
      end
    end

    class Strategy::EmailAndPassword < Strategy
      def initialize(email, password)
        @email, @password = email, password
      end

      def find
        user = User.find_by_email_and_provider(@email, :pasher)
        if user && user.password_hash == BCrypt::Engine.hash_secret(@password, user.password_salt)
          user
        else
          nil
        end
      end
    end
  end

end