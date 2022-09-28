module SessionsHelper
      
    # Logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end
    
    def current_user
        if session[:user_id]
           @current_user ||= User.find_by(id: session[:user_id]) #means if current user is null then do the find by from the db
        end 
    end


  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user. def log_out
  def log_out
    reset_session
    @current_user = nil
  end
  
end
