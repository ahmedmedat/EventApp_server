class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def logged_in?
    current_user
  end
  #helper_method :logged_in?

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    #elsif cookies.permanent.signed[:remember_me_token]
     # verification = Rails.application.message_verifier(:remember_me).verify(cookies.permanent.signed[:remember_me_token])
      #if verification
       # Rails.logger.info "Logging in by cookie."
        #@current_user ||= User.find(verification)
      #end
    end
  end
  helper_method :current_user

  def require_user
    if current_user
      true
    #else
     # redirect_to new_user_session_path, notice: "You must be logged in to access that page."
    end
  end

end
