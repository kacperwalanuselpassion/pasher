class User::UserCreatorService
  def create_from_google_oauth_request(auth)
    User.
      where(provider: auth['provider'], uid: auth['uid']).
      first_or_initialize(
        refresh_token: auth['credentials']['refresh_token'],
        access_token: auth['credentials']['token'],
        expires: auth['credentials']['expires_at'],
        name: auth['info']['name'],
        email: auth['info']['email']
      )
  end
end