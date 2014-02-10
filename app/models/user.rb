class User < ActiveRecord::Base
  require 'digest/md5'
  attr_accessible :name,
                  :provider,
                  :uid,
                  :refresh_token,
                  :access_token,
                  :expires,
                  :email,
                  :password,
                  :password_confirmation

  attr_accessor :password

  validates_uniqueness_of :email
  validates_confirmation_of :password, if: :pasher_provider?
  validates_presence_of :password, :on => :create, if: :pasher_provider?
  validates_uniqueness_of :uid, :scope => :provider

  def gravatar_url
    'http://www.gravatar.com/avatar/' + Digest::MD5.hexdigest(email) + '?d=identicon'
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def pasher_provider?
    provider.in? ['pasher', :pasher]
  end
end
