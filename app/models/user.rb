class User < ActiveRecord::Base
  require 'digest/md5'
  attr_accessible :name, :provider, :uid, :refresh_token, :access_token, :expires, :email

  validates_uniqueness_of :uid, :scope => :provider

  def gravatar_url
    'http://www.gravatar.com/avatar/' + Digest::MD5.hexdigest(email)
  end
end
