class UsersController < ApplicationController
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # Create object for _form
  def new
    @user = User.new
  end

  # Create user
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # Destroy user
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url
  end
end
