class SessionsController < ApplicationController

  def create
    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      session[:user_id] = @user.id
      flash[:info] = "Welcome, #{@user.name}!"
      redirect_to conferences_path
    rescue
      flash[:danger] = 'There was an error while trying to authenticate you.'
      redirect_to root_path
    end
  end

  def destroy
    if current_user
      session.delete(:user_id)
    end
    redirect_to root_path
  end

end
