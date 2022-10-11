class ApplicationController < ActionController::Base
    # before_action :authenticate_user!
   
    def require_user
        if (Redis.current.get("shopper_id") == nil && Redis.current.get("company_id") == nil && Redis.current.get("retailer_id") == nil)
            flash[:alert] = "You must be logged in"
            redirect_to '/'
        end
    end


    
   
end