class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    # debugger
  end
  
  def new
    @user = User.new
    # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # redirect_to user_url(@user) we could have used this as well but rails automatically knows we want the user_url above
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end


  private
      def user_params
        params.require(:user).permit(:name, :email, :password,:password_confirmation)
      end
end
