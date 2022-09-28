module SessionsHelper
      
    # Logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end
    
    # def current_user
    #     if session[:user_id]
    #        @current_user ||= User.find_by(id: session[:user_id]) #means if current user is null then do the find by from the db
    #     end 
    # end

    # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id]) # reads as if user_id in sessions is not null then assign it to user_id
      user = User.find_by(id: user_id)
      # @current_user ||= User.find_by(id: user_id) ex 9.3.2
      @current_user ||= user if session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end 
  end

  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user. def log_out
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
  
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id 
    cookies.permanent[:remember_token] = user.remember_token
  end    

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
