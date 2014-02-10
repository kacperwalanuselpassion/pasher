class UsersController < ApplicationController
  def new
    render 'users/forms/create_account'
  end

  def login
    render 'users/forms/login'
  end
end