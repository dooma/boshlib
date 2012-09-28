class UsersController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, :only => [:new, :create, :activate]

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
      redirect_to @user, notice: 'User was successfully created. Please activate email first!'
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

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to root_path, :notice => "Activation successfully"
    else
      redirect_to root_path, :alert => "Account can not be activate"
    end
  end
end
