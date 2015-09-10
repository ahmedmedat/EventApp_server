class AccessController < ApplicationController
    skip_before_filter :verify_authenticity_token
    protect_from_forgery with: :null_session
    #before_filter :authenticate
    
    def current_user
       @current_user     
    end
  
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
       Rails.logger.info "API authentication:#{username} #{password}"
        user = User.find_by_username(username)
        if user 
          @current_user = user
          Rails.logger.info "Logging in #{user.inspect}"
          true
        else
          Rails.logger.warn "No valid credentials."
          false
        end
      end
    
    end  
end
