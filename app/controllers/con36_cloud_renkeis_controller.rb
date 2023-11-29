class Con36CloudRenkeisController < ApplicationController

    def index
    end

    # 実行
    def create
        
        # 実行した時にカーソルを砂時計にする処理を記述する
        # @@debug.pri_logger.error(params[:kbn_syori])
        
        case params[:kbn_syori].to_s
            when "1" then
        
                CloudRenUser.table_delete
                CloudRenShisetu.table_delete
                CloudRenCheck.table_delete

                ret, msg = CloudRenUser.table_insert

                if ret
                    ret, msg = CloudRenShisetu.table_insert(CloudRenUser.table_select)

                    if ret
                        cloudrenusers = CloudRenUser.table_select_join
                        ret, msg = CloudRenCheck.table_insert(cloudrenusers)
                        
                        if ret
                            rakurenseikyus = RakuRenSeikyu.table_select_join(1)
                            id_max = CloudRenCheck.table_maximum
                            ret, msg, id_max = CloudRenCheck.table_insert_kizon(rakurenseikyus, 1, id_max)
                            
                            # @@debug.pri_logger.error("終わり１")
                            # @@debug.pri_logger.error("id_max = #{id_max}")
                            
                            if ret
                                rakurenseikyus = RakuRenSeikyu.table_select_join(2)
                                ret, msg, id_max = CloudRenCheck.table_insert_kizon(rakurenseikyus, 2, id_max)
                                
                                if ret
                                    rakurenseikyus = RakuRenSeikyu.table_select_group
                                    ret, msg = CloudRenCheck.table_select(rakurenseikyus)

                                    if ret 
                                        msg = "Sofinet Cloudからローカルテーブルに、一括でデータを取得しました。"
                                        msg << "既存の請求システムには、データは反映していません。"
                                        msg << "<pre>"
                                        msg << "　全ユーザー　：　#{CloudRenUser.table_count.to_s(:delimited).rjust(7)} 件<br>"
                                        msg << "　全施設　　　：　#{CloudRenShisetu.table_count.to_s(:delimited).rjust(7)} 件"
                                        msg << "</pre>"
                                    end
                                end
                            end
                        end
                    end
                end

            when "2" then

                CloudRenWork3.table_delete
                cloudrenchecks = CloudRenCheck.table_select_newshisetu(syori: "key_tanitsu")
                ret, msg = CloudRenWork3.table_insert(cloudrenchecks, syori: "key_tanitsu")

                if ret
                    cloudrenchecks = CloudRenCheck.table_select_newshisetu(syori: "key_jyufuku")
                    ret, msg = CloudRenWork3.table_insert(cloudrenchecks, syori: "key_jyufuku")
                    if ret
                        # 処理結果を出力させる
                        msg = "新規施設のExcel出力を行いました。"
                        msg << "既存の請求システムには、データは反映していません。"
                        msg << "<pre>"
                        msg << "　単一キー　：　#{CloudRenWork3.table_count(syori: "key_tanitsu").to_s(:delimited).rjust(7)} 件<br>"
                        msg << "　重複キー　：　#{CloudRenWork3.table_count(syori: "key_jyufuku").to_s(:delimited).rjust(7)} 件"
                        msg << "</pre>"
                    end
                end
            else
                msg = "処理区分が正しく選択されていないため、処理を中断しました。"
                ret = false
        end

        if ret
            flash[:notice] = msg
        else
            flash[:alert] = msg
        end
        
        redirect_to con36_cloud_renkeis_url(kbn_syori: params[:kbn_syori])
    end


    # インポート１（請求）　処理１
    def import_seikyu

        # ファイルの取り込みチェック
        ret, msg = Common.check_file(params[:file])
        flash[:alert] = msg unless ret.zero?

        if ret.zero?
            # テーブルの一括削除
            RakuRenSeikyu.table_delete

            # CSVのインポート
            ret, msg = RakuRenSeikyu.table_import(params[:file])
            flash[:notice] = msg if ret
            flash[:alert]  = msg if !ret
        end
        redirect_to con36_cloud_renkeis_url
    end

    # インポート２（施設）　処理２
    def import_shisetu

        # ファイルの取り込みチェック
        ret, msg = Common.check_file(params[:file])
        flash[:alert] = msg unless ret.zero?

        if ret.zero?
            # テーブルの一括削除
            RakuRenShisetu.table_delete

            # CSVのインポート
            ret, msg = RakuRenShisetu.table_import(params[:file])
            flash[:notice] = msg if ret
            flash[:alert]  = msg if !ret
        end
        redirect_to con36_cloud_renkeis_url
    end

    # ---------------------------------------------------------
    # 新規/廃止ユーザーのExcel出力　《Excelユーザー》
    # ---------------------------------------------------------
    def export_user

        @cloudrencheck = CloudRenCheck.table_select_forexcel

        filename = "クラウド連携_#{Time.current.strftime("%m%d")}"
        respond_to do |format|
            format.xlsx do
                response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xlsx"
            end
        end
        render :export_user
    end

    # ---------------------------------------------------------
    # 新規施設のExcel出力 《Excel施設》
    # ---------------------------------------------------------
    def export_shisetu

        # テーブル間のER図を作成
        # Accessでは単一キー、重複キーの場合とExcelファイルを２つに分けていたが、Railsでは１つのファイルにせざるを得ないこととなった

        # 単一キーの場合
        @cloudrenwork3s_tanitsu = CloudRenWork3.table_select_forexcel(syori: "key_tanitsu")
        
        # 重複キーの場合
        @cloudrenwork3s_jyufuku = CloudRenWork3.table_select_forexcel(syori: "key_jyufuku")

        filename = "クラウド連携_新規更新分_#{Time.current.strftime("%m%d")}"
        respond_to do | format |
            format.xlsx do
                response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xlsx"
            end
        end
        render :export_shisetu
    end
end
