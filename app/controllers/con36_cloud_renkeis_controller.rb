class Con36CloudRenkeisController < ApplicationController

    def index
    end

    # 実行
    def create
        
        ret, msg = nil, ""

        catch(:goto_err) do

            case params[:kbn_syori].to_s
                when "1" then
                    
                    # テーブルを全件削除
                    CloudRenUser.table_delete
                    CloudRenShisetu.table_delete
                    CloudRenCheck.table_delete
                    
                    # SofinetCloudからAPI連携（ユーザー）
                    ret, msg = CloudRenUser.table_insert
                    throw :goto_err if !ret
                    
                    # SofinetCloudからAPI連携（施設）
                    ret, msg = CloudRenShisetu.table_insert(CloudRenUser.table_select)
                    throw :goto_err if !ret
                    
                    # 新規ユーザーだけを更新（SofinetCloud側：有 楽楽側：無）
                    cloudrenusers = CloudRenUser.table_select_join
                    ret, msg = CloudRenCheck.table_insert(cloudrenusers)
                    throw :goto_err if !ret
                    
                    # 既存、廃止ユーザーだけを更新（SofinetCloud側：有 楽楽側：有、 SofinetCloud側：無 楽楽側：有 団体区分=1:自治体）
                    rakurenseikyus = RakuRenSeikyu.table_select_join(dantai_kbn: 1)
                    id_max = CloudRenCheck.table_maximum
                    ret, msg, id_max = CloudRenCheck.table_insert_kizon(rakurenseikyus, id_max, dantai_kbn: 1)
                    throw :goto_err if !ret
                    
                    # 既存、廃止ユーザーだけを更新（SofinetCloud側：有 楽楽側：有 SofinetCloud側：無 楽楽側：有 団体区分=2:民間）
                    rakurenseikyus = RakuRenSeikyu.table_select_join(dantai_kbn: 2)
                    ret, msg, id_max = CloudRenCheck.table_insert_kizon(rakurenseikyus, id_max, dantai_kbn: 2)
                    throw :goto_err if !ret
                    
                    # データ区分を更新（ユーザーキーが複数存在する場合、任意に１データを決定する）
                    rakurenseikyus = RakuRenSeikyu.table_select_group
                    ret, msg = CloudRenCheck.table_select_save(rakurenseikyus)

                    if ret 
                        msg = "Sofinet Cloudからローカルテーブルに、一括でデータを取得しました。"
                        msg << "既存の請求システムには、データは反映していません。"
                        msg << "<pre>"
                        msg << "　全ユーザー　：　#{CloudRenUser.table_count.to_s(:delimited).rjust(7)} 件<br>"
                        msg << "　全施設　　　：　#{CloudRenShisetu.table_count.to_s(:delimited).rjust(7)} 件"
                        msg << "</pre>"
                    end
                    
                when "2" then
                    
                    catch(:goto_err) do
                        # テーブルを全件削除
                        CloudRenWork3.table_delete
                        
                        # Excel出力用ワークファイルへのデータ抽出（ユーザーキー：単位）
                        cloudrenchecks = CloudRenCheck.table_select_newshisetu(syori: "key_tanitsu")
                        ret, msg = CloudRenWork3.table_insert(cloudrenchecks, syori: "key_tanitsu")
                        throw :goto_err if !ret
                        
                        # Excel出力用ワークファイルへのデータ抽出（ユーザーキー：重複）
                        cloudrenchecks = CloudRenCheck.table_select_newshisetu(syori: "key_jyufuku")
                        ret, msg = CloudRenWork3.table_insert(cloudrenchecks, syori: "key_jyufuku")
                        
                        if ret
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
        end

        if ret
            flash[:notice] = msg
        else
            flash[:alert] = msg
        end
        redirect_to con36_cloud_renkeis_url(kbn_syori: params[:kbn_syori])
    end

    # 処理１（請求）
    def import_seikyu

        # ファイルの取り込みチェック
        ret, msg = Common.check_file(params[:file])
        flash[:alert] = msg if !ret.zero?

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

    # 処理２（施設）
    def import_shisetu

        # ファイルの取り込みチェック
        ret, msg = Common.check_file(params[:file])
        flash[:alert] = msg if !ret.zero?

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

    # Excelユーザー（Excel出力）
    def export_user

        # データ取得
        @cloudrencheck = CloudRenCheck.table_select_forexcel

        filename = "クラウド連携_#{Time.current.strftime("%m%d")}"
        respond_to do |format|
            format.xlsx do
                response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xlsx"
            end
        end
        render :export_user
    end

    # Excel施設（Excel出力）
    # コメント：Accessでは単一キー、重複キーの場合とExcelファイルを２つに分けていたが、Railsでは１つのファイルにせざるを得ないこととなった
    def export_shisetu

        # データ取得（単一キーの場合）
        @cloudrenwork3s_tanitsu = CloudRenWork3.table_select_forexcel(syori: "key_tanitsu")
        
        # データ取得（重複キーの場合）
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
