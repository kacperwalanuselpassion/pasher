class User::UserCreatorService
  def create_from_google_oauth_request(auth)
    user = User.new(
      provider: auth['provider'],
      uid: auth['uid'],
      refresh_token: auth['credentials']['refresh_token'],
      access_token: auth['credentials']['token'],
      expires: auth['credentials']['expires_at'],
      name: auth['info']['name'],
      email: auth['info']['email']
    )
    user.save!
    user
  end

  def create_from_pasher_auth_request(params)
    user = User.new(
      provider: :pasher,
      uid: SecureRandom.uuid,
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      name: params[:name]
    )
    user.encrypt_password
    user.save!
    user
  end
end