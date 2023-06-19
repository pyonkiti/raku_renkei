class Con37NyushiSeikyusController < ApplicationController
    
    def index
    end

    # ---------------------------------------------------------
    # 請求月計算 ／ 請求予定額計算 《実行》
    # ---------------------------------------------------------
    def syori_main
        
        # ---------------------------------------------------------
        # 請求年月の入力チェック
        # ---------------------------------------------------------
        unless params[:txt_seikyu_ym].present?
            flash[:alert]  = "請求年月が空白です。"
        else
            
            ret = case params[:kbn_seikyu]
                when "1" then SeikyuTukiCal.proc_main(0, params[:txt_seikyu_ym])    # 請求月数計算
                when "2" then SeikyuYoteCal.proc_main(params[:txt_seikyu_ym])       # 請求予定額計算
            end

            msg = "「請求月計算テーブル」" if params[:kbn_seikyu] == "1"
            msg = "「請求予定額テーブル」" if params[:kbn_seikyu] == "2"

            unless ret
                flash[:alert]  = "#{msg}の更新でエラーが発生しました。"
            else
                flash[:notice] = "#{msg}の更新が完了しました。"
            end
        end
        
        redirect_to con37_nyushi_seikyus_url(seikyu_ym: params[:txt_seikyu_ym], kbn_seikyu: params[:kbn_seikyu])
    end
    
    # ---------------------------------------------------------
    # 請求月計算 《CSV出力》
    # ---------------------------------------------------------
    def export_tuki
        
        sql = "Select * From seikyu_tuki_cals Order by sisetu_kanribu_teisyutu0_id"
        @ex_seikyu = SeikyuTukiCal.find_by_sql(sql)
        
        if ( @ex_seikyu.size == 0 )
            flash[:alert]  = "請求月計算テーブルのデータ件数は0件です。"
            redirect_to con37_nyushi_seikyus_url
            return
        end

        filename = params[:txt_seikyus_ym].present? ? "#{params[:txt_seikyus_ym].delete("-")}" : ""
        
        respond_to do |format|
            format.csv do
                send_data SeikyuTukiCal.proc_csv(@ex_seikyu), filename: "請求月計算_#{filename}.csv"
            end
        end
    end


    # ---------------------------------------------------------
    # 請求予定額計算 《Excel出力》
    # ---------------------------------------------------------
    def export_yote

        sql = "Select * From seikyu_yote_cals Order by id"
        @ex_seikyu = SeikyuYoteCal.find_by_sql(sql)

        if ( @ex_seikyu.size == 0 )
            flash[:alert]  = "請求予定額テーブルのデータ件数は0件です。"
            redirect_to con37_nyushi_seikyus_url
            return
        end

        filename = params[:txt_seikyus_ym].present? ? "#{params[:txt_seikyus_ym].delete("-")}" : ""

        respond_to do |format|
            format.xlsx do
                response.headers['Content-Disposition'] = "attachment; filename=請求予定額_#{filename}.xlsx"
            end
        end
    end

end
 