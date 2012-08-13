class UserSessionsController < ApplicationController

  # Create object for login form
  def new
    @user = User.new
  end

  # Create session
  def create
    if @user = login(params[:username], params[:password])
      redirect_back_or_to root_path, :notice => "Login successful."
    else
      redirect_to root_path, :alert => "Login unsuccessful."
      render "new"
    end
  end

  # Destroy session
  def destroy
    logout
    redirect_to :root_path, :notice => "Logout successful."
  end
end
