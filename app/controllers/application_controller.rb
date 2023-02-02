class ApplicationController < ActionController::Base

    helper_method :current_user
    before_action :login_required
    
    @@debug = Rails.application.config       # デバック用

    private

    def current_user
        @current_user ||= Master::User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def login_required
        redirect_to master_login_url unless current_user
    end
end
