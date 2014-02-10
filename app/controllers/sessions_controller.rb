class SessionsController < ApplicationController

  rescue_from Errors::PasherError, with: :redirect_to_sign_in_page_and_show_errors
  rescue_from ActiveRecord::RecordInvalid, with: :redirect_to_sign_in_page_and_show_errors

  def create
    user = find_or_create_user
    raise Errors::PasherError.new('Login failed') unless user

    url = session[:return_to] || root_path
    session[:return_to] = nil
    url = root_path if url.eql?('/logout')

    session[:user_id] = user.id
    notice = 'Signed in!'
    redirect_to url, :notice => notice
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end

  private

  def find_or_create_user
    @user = if google_auth_callback_request?
             find_user || create_user
           elsif email_and_password_auth_request?
             find_user
           elsif pasher_sign_up_request?
             create_user
           end
  end

  def find_user
    user_finder = User::UserFinderService.new
    user_finder.strategy =
        if google_auth_callback_request?
          User::UserFinderService::Strategy::GoogleAuthRequest.new(omniauth_auth_env)
        elsif email_and_password_auth_request?
          User::UserFinderService::Strategy::EmailAndPassword.new(params[:email], params[:password])
        else
          raise Errors::PasherError.new('Could not recognize authorization request')
        end

    user_finder.find
  end

  def create_user
    if google_auth_callback_request?
      User::UserCreatorService.new.create_from_google_oauth_request(omniauth_auth_env)
    elsif pasher_sign_up_request?
      User::UserCreatorService.new.create_from_pasher_auth_request(params)
    end
  end

  def redirect_to_sign_in_page_and_show_errors(exception)
    flash[:notice] = exception.message
    redirect_to '/sign_in'
  end

  def omniauth_auth_env
    request.env['omniauth.auth']
  end

  def email_and_password_auth_request?
    params[:from] == 'login_form'
  end

  def pasher_sign_up_request?
    params[:from] == 'sign_up_form'
  end

  def google_auth_callback_request?
    omniauth_auth_env.try(:[], 'provider') == 'google_login'
  end

end
