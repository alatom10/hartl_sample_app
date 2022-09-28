class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    if user&.authenticate(params[:session][:password]) # this uses the safe navigation operator &. which is the same as the above
          # Log the user in and redirect to the user's show page.
      reset_session
      log_in user
      redirect_to user
    else
        # Create an error message.
        # flash[:danger] = 'Invalid email/password combination' # Not quite right! - we use flash.now instead as flash does not consider render a new request but flash.now considers all and displays once
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
