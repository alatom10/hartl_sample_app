class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #chapter 10.2.1 and listing 10.58 pg 612
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,   only: :destroy
  
  def index 
    # @users = User.all
    # @users = User.paginate(page: params[:page]) # pagination implemented, params[:page] is automatically gen'd by will_paginate
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page]) #get the microposts
    # redirect_to root_url and return unless @user.activated #removed in 13.2 pg 744
    # debugger
  end
  
  def new
    @user = User.new
    # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # reset_session #removed in chp 10 pg 558
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # redirect_to user_url(@user) we could have used this as well but rails automatically knows we want the user_url above
      # the above was removed due to email activation that was set up in chp 11 pg 646
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    # @user = User.find(params[:id])   pg 576 removed bacause the before_action :correct_user checks the correct user already
  end

  def update
    # @user = User.find(params[:id]) pg 576
    if @user.update(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
  else
      render 'edit'
    end
  end

  private
      def user_params
        params.require(:user).permit(:name, :email, :password,:password_confirmation)
      end


      # before filters
          # Confirms a logged-in user.
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end 
      end

    # Confirms the correct user.
      def correct_user
        @user = User.find(params[:id]) 
        # redirect_to(root_url) unless @user == current_user # replaced with below pg 579 due to current_user method created in the sessions helper
        redirect_to(root_url) unless current_user?(@user)
      end

      # Confirms an admin user. 
      def admin_user
        redirect_to(root_url) unless current_user.admin? 
      end
end
