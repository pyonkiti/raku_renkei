class Master::UsersController < ApplicationController
  
    before_action :user_find, only: [:show, :edit, :update, :destroy]

    def index
        @users = Master::User.all.order(:id)
    end

    def show
    end

    def new
        @user = Master::User.new
    end

    def edit
    end

    def create
        @user = Master::User.new(user_params)
        if @user.save
            redirect_to master_user_url(@user)
            flash[:notice] = "ユーザー「#{@user.name}」 を登録しました。"
        else
            render :new
        end
    end

    def update
        if @user.update(user_params)
            redirect_to master_user_url
            flash[:notice] = "ユーザー「#{@user.name}」 を更新しました。"
        else
            render :edit
        end
    end

    def destroy
        @user.destroy
        flash[:notice] = "#{@user.name} を削除しました。"
        redirect_to master_users_url
    end

    private

    def user_find
        @user = Master::User.find(params[:id])
    end

    def user_params
        params.require(:master_user).permit(
            :name,
            :name_id,
            :password,
            :password_confirmation,
            :admin
        )
    end
end
