class SeikyuTukiReigaisController < ApplicationController
    
    before_action :seikyutukireigai_find, only: [:show, :edit, :update, :destroy]

    def index
        @seikyutukireigais = SeikyuTukiReigai.all.order(:seikyu_key_link, :id)
    end

    def show
    end

    def new
        @seikyutukireigai = SeikyuTukiReigai.new
    end

    def edit
    end
    
    def create

        @seikyutukireigai = SeikyuTukiReigai.new(seikyutukireigai_params)

        if @seikyutukireigai.save
            flash[:notice] = "「ID : #{@seikyutukireigai.id}」  を登録しました。"
            redirect_to seikyu_tuki_reigais_path
        else
            flash[:alert] = @seikyutukireigai.errors.full_messages[0]
            render :new
        end
    end

    def update
        
        if @seikyutukireigai.update(seikyutukireigai_params)
            flash[:notice] = "「ID : #{@seikyutukireigai.id}」  を更新しました。"
            redirect_to seikyu_tuki_reigais_path
        else
            flash[:alert] = @seikyutukireigai.errors.full_messages[0]
            render :edit
        end
    end

    def destroy
        @seikyutukireigai.destroy
        flash[:notice] = "「ID : #{@seikyutukireigai.id}」  を削除しました。"
        redirect_to seikyu_tuki_reigais_path
    end

    private

    def seikyutukireigai_find
        @seikyutukireigai = SeikyuTukiReigai.find(params[:id])
    end

    def seikyutukireigai_params
        params.require(:seikyu_tuki_reigai).permit(
            :seikyu_key_link,
            :sisetu_nm,
            :seikyu_m_su,
            :biko_user,
            :biko_siyou
        )
    end
end
