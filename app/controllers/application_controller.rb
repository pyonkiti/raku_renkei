class ApplicationController < ActionController::Base

    helper_method :current_user
    before_action :login_required
    
    @@debug          = Rails.application.config                                           # デバック用
    @@assen_file_mot = "./excel/moto/支払手数料明細表_原紙.xlsx"                            # 斡旋手数料のExcelファイル（元）
    @@assen_file_out = "./excel/支払手数料明細表_#{Time.current.strftime("%Y%m")}.xlsx"     # 斡旋手数料のExcelファイル（先）

    private

    def current_user
        @current_user ||= Master::User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def login_required
        redirect_to master_login_url unless current_user
    end
end
