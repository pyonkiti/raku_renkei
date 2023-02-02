class Master::SessionsController < ApplicationController
    
    skip_before_action :login_required
    
    def new
    end

    def create

        user = User.find_by(name_id: params[:session][:name_id])

        # tttttttttttttt
        # session[:user_id] = user.id
        # redirect_to con37_nyushi_excels_url

        if user&.authenticate(params[:session][:password])
            session[:user_id] = user.id
            flash[:notice] = "ログインしました。"
            redirect_to con37_nyushi_excels_url
        else
            flash[:alert] = "ログインに失敗しました。"
            render :new
        end
    end

    def destroy
        reset_session
        flash[:notice] = "ログアウトしました。"
        redirect_to master_login_url
    end

    private

    def session_params
    end
end
