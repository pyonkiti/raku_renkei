class Con36CloudRenkeisController < ApplicationController

    def index
    end

    # 処理１（請求）
    def import_seikyu

        ret, msg = nil, nil
        time_measure = {str: 0, end: 0}

        catch(:goto_err) do

            # ファイルの取り込みチェック
            ret, msg = Common.check_file(params[:file])
            ret = ret.zero? ? true : false
            throw :goto_err if !ret

            # 時間計測の開始
            time_measure[:str] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

            # テーブルの一括削除
            RakuRenSeikyu.table_delete

            # CSVのインポート
            ret, msg = RakuRenSeikyu.table_import(params[:file])
            throw :goto_err if !ret

            # 時間計測の終了
            time_measure[:end] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        end
        
        measure_frm = time_measure[:end] - time_measure[:str] >= 60 ? "%M分%S秒" : "%S秒"
        measure_msg = Time.at(time_measure[:end] - time_measure[:str]).utc.strftime(measure_frm)

        if ret
            flash[:notice] = msg + "　（処理時間 #{measure_msg}）"
        else
            flash[:alert] = msg
        end
        redirect_to con36_cloud_renkeis_url
    end

    # 処理２（施設）
    def import_shisetu

        ret, msg = nil, nil
        time_measure = {str: 0, end: 0}

        catch(:goto_err) do

            # ファイルの取り込みチェック
            ret, msg = Common.check_file(params[:file])
            ret = ret.zero? ? true : false
            throw :goto_err if !ret

            # 時間計測の開始
            time_measure[:str] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

            # テーブルの一括削除
            RakuRenShisetu.table_delete

            # CSVのインポート
            ret, msg = RakuRenShisetu.table_import(params[:file])
            throw :goto_err if !ret

            # 時間計測の終了
            time_measure[:end] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        end

        measure_frm = time_measure[:end] - time_measure[:str] >= 60 ? "%M分%S秒" : "%S秒"
        measure_msg = Time.at(time_measure[:end] - time_measure[:str]).utc.strftime(measure_frm)

        if ret
            flash[:notice] = msg + "　（処理時間 #{measure_msg}）"
        else
            flash[:alert] = msg
        end
        redirect_to con36_cloud_renkeis_url
    end

    # 実行
    def create
        
        ret, msg = nil, ""
        time_measure = {str: 0, end: 0}

        catch(:goto_err) do

            time_measure[:str] = Process.clock_gettime(Process::CLOCK_MONOTONIC)    # 時間計測の開始

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
                    throw :goto_err if !ret
                    
                when "2" then
                    
                    # テーブルを全件削除
                    CloudRenWork3.table_delete
                    
                    # Excel出力用ワークファイルへのデータ抽出（ユーザーキー：単位）
                    cloudrenchecks = CloudRenCheck.table_select_newshisetu(syori: "key_tanitsu")
                    ret, msg = CloudRenWork3.table_insert(cloudrenchecks, syori: "key_tanitsu")
                    throw :goto_err if !ret
                    
                    # Excel出力用ワークファイルへのデータ抽出（ユーザーキー：重複）
                    cloudrenchecks = CloudRenCheck.table_select_newshisetu(syori: "key_jyufuku")
                    ret, msg = CloudRenWork3.table_insert(cloudrenchecks, syori: "key_jyufuku")
                    throw :goto_err if !ret
                else
                    msg = "処理区分が正しく選択されていないため、処理を中断しました。"
                    ret = false
                    throw :goto_err if !ret
            end
            
            time_measure[:end] = Process.clock_gettime(Process::CLOCK_MONOTONIC)    # 時間計測の終了
            
            measure_frm = time_measure[:end] - time_measure[:str] >= 60 ? "%M分%S秒" : "%S秒"
            measure_msg = Time.at(time_measure[:end] - time_measure[:str]).utc.strftime(measure_frm)
            
            case params[:kbn_syori].to_s
                when "1"
                    msg = "Sofinet Cloudからローカルテーブルに、一括でデータを取得しました。" + "　（処理時間 #{measure_msg}）"
                    msg << "<pre>"
                    msg << "　ユーザー数　：　#{CloudRenUser.table_count.to_s(:delimited).rjust(7)} 件<br>"
                    msg << "　施設数　　　：　#{CloudRenShisetu.table_count.to_s(:delimited).rjust(7)} 件"
                    msg << "</pre>"
                when "2"
                    msg = "新規施設のExcel出力を行いました。" + "　（処理時間 #{measure_msg}）"
                    msg << "<pre>"
                    msg << "　単一キー　：　#{CloudRenWork3.table_count(syori: "key_tanitsu").to_s(:delimited).rjust(7)} 件<br>"
                    msg << "　重複キー　：　#{CloudRenWork3.table_count(syori: "key_jyufuku").to_s(:delimited).rjust(7)} 件"
                    msg << "</pre>"
            end
        end

        if ret
            flash[:notice] = msg
        else
            flash[:alert] = msg
        end

        redirect_to con36_cloud_renkeis_url(kbn_syori: params[:kbn_syori])
    end
    
    # Excelユーザー（Excel出力）
    def export_user

        # データ取得
        @cloudrencheck = CloudRenCheck.table_select_where_forexcel

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
