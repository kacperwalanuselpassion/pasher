Rails.application.config.middleware.use OmniAuth::Builder do
  google_client_id     = ENV['GOOGLE_CLIENT_ID']
  google_client_secret = ENV['GOOGLE_CLIENT_SECRET']
  auth_domain          = ENV['AUTH_DOMAIN']
  ssl_ca_file          = ENV['SSL_CA_FILE']

  raise('You must specify Google OAuth 2.0 Client ID') if google_client_id.blank?
  raise('You must specify Google OAuth 2.0 Client Secret') if google_client_secret.blank?
  raise('You must specify SSL CA File') if Rails.env.production? && ssl_ca_file.blank?

  Rails.logger.warn('Auth Domain is not specified. Users are allowed to authenticate using any domain.') if auth_domain.blank?
  Rails.logger.warn('SSL CA File is not specified. Problems may occur when authenticating using Google OAuth 2.0.') if ssl_ca_file.blank?

  oauth2_options                  = {access_type: 'online', name: 'google_login', approval_prompt: ''}
  oauth2_options[:hd]             = auth_domain if auth_domain.present?
  oauth2_options[:client_options] = {ssl: {ca_file: ssl_ca_file}} if ssl_ca_file.present?

  provider :google_oauth2, google_client_id, google_client_secret, oauth2_options
end
