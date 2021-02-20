class ApplicationController < ActionController::Base
    before_action :validate_token
    def validate_token
        token = cookies[:token]
        auth_service = AuthService.new()
        if auth_service.validate_token(token)
            true
        else
            render :file => "public/401.html", :status => :unauthorized
        end
    end
end