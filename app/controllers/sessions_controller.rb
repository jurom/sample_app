class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
	# Sign in
	flash[:success] = "Welcome #{user.name} !"
	sign_in user
	redirect_to user
    else 
	# Error
	flash.now[:error] = "Invalid email/password combination"
	render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end

