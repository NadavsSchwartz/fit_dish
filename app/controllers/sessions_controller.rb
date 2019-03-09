class SessionsController < ApplicationController

  def new
  end

  def create
    if auth_hash = request.env["omniauth.auth"]
      @user = User.find_or_create_from_facebook(auth_hash)
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      authenticate_user
    end
  end

  def authenticate_user
    @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        flash.now[:danger] = "Login Error: Try Again!"
        render :new
      end
  end

  def destroy
    session.delete :user_id
    redirect_to '/'
  end

end
