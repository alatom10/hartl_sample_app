class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) 
    # if user && user.authenticate(params[:session][:password])
    if user&.authenticate(params[:session][:password]) # this line uses the safe nav operator which is imilar to the above
          # Log the user in and redirect to the user's show page.
      reset_session
      log_in user
      redirect_to user
    else
          # Create an error message.
        # flash[:danger] = 'Invalid email/password combination' # Not quite right!
      flash.now[:danger] = 'Invalid email/password combination' #flash.now disappears as soon as an additional request like render 'new' is called. We use this because..
        # Flash itself does not look at render as a new request
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
