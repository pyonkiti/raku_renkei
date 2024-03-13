class Con37NyushiExcelsController < ApplicationController

    def index

        # 直近の更新日時を画面表示
        @table0s = SisetuKanribuTeisyutu0.select(:id, :created_at).order(id: "DESC").limit(1)
        @table1s = SisetuKanribuTeisyutu1.select(:id, :created_at).order(id: "DESC").limit(1)
        @table2s = SisetuKanribuTeisyutu2.select(:id, :created_at).order(id: "DESC").limit(1)
        @table3s = SisetuKanribuTeisyutu3.select(:id, :created_at).order(id: "DESC").limit(1)

        # 直近のデータ件数を画面表示
        @tbl0_cnt = SisetuKanribuTeisyutu0.table_count(1)
        @tbl1_cnt = SisetuKanribuTeisyutu1.table_count(1)
        @tbl2_cnt = SisetuKanribuTeisyutu2.table_count(1)
        @tbl3_cnt = SisetuKanribuTeisyutu3.table_count(1)
    end

    # ---------------------------------------------------------
    # 楽楽からCSVファイル1 《インポート》
    # ---------------------------------------------------------
    def import1
        
        ret, msg = nil, nil

        catch(:goto_err) do

            # ファイル取り込みのチェック
            ret, msg = Common.check_file(params[:file])
            ret = ret.zero? ? true : false
            throw :goto_err if !ret

            # 一括削除
            SisetuKanribuTeisyutu1.table_delete

            # CSVファイルの取り込み
            ret, msg = SisetuKanribuTeisyutu1.table_import(params[:file])
        end
        
        if ret
            flash[:notice] = msg
        else
            flash[:alert] = msg
        end
        redirect_to con37_nyushi_excels_url
    end


    # ---------------------------------------------------------
    # 楽楽からCSVファイル2 《インポート》
    # ---------------------------------------------------------
    def import2

        ret, msg = nil, nil

        catch(:goto_err) do
            
            # ファイル取り込みのチェック
            ret, msg = Common.check_file(params[:file])
            ret = ret.zero? ? true : false
            throw :goto_err if !ret

            # 一括削除
            SisetuKanribuTeisyutu2.table_delete
            
            # CSVファイルの取り込み
            ret, msg = SisetuKanribuTeisyutu2.table_import(params[:file])
        end

        if ret
            flash[:notice] = msg
        else
            flash[:alert] = msg
        end
        redirect_to con37_nyushi_excels_url
    end

    # ---------------------------------------------------------
    # 楽楽からCSVファイル3 《インポート》
    # ---------------------------------------------------------
    def import3

        ret, msg = nil, nil

        catch(:goto_err) do

            # ファイル取り込みのチェック
            ret, msg = Common.check_file(params[:file])
            ret = ret.zero? ? true : false
            throw :goto_err if !ret

            # 一括削除
            SisetuKanribuTeisyutu3.table_delete

            # CSVファイルの取り込み
            ret, msg = SisetuKanribuTeisyutu3.table_import(params[:file])
        end

        if ret
            flash[:notice] = msg
        else
            flash[:alert] = msg
        end
        redirect_to con37_nyushi_excels_url
    end

    # ---------------------------------------------------------
    # 《実行》
    # ---------------------------------------------------------
    def syori0
        
        @msg = []

        # インポートした2つのCSVファイルを結合して、テーブル0に更新
        unless SisetuKanribuTeisyutu0.table_insert_main
            alert  = "管理部提出データ出力１・２・３の結合処理で、エラーが発生しました。"
        else
            @msg << "「管理部提出データ出力テーブル１・２・３」の結合が完了しました。　処理件数は #{SisetuKanribuTeisyutu0.table_count(1)} 件です。"

            # 入金仕入Excel_仕入一覧の更新
            unless ExcelShiireList.proc_main
                alert  = "入金仕入Excel_仕入一覧の更新処理で、エラーが発生しました。"
            else
                @msg << "「仕入一覧テーブル」の更新が完了しました。　処理件数は #{ExcelShiireList.table_count(1)} 件です。"

                # 入金仕入Excel_入金一覧の更新
                unless ExcelNyukinList.proc_main
                    alert  = "入金仕入Excel_入金一覧の更新処理で、エラーが発生しました。"
                else
                    @msg << "「入金一覧テーブル」の更新が完了しました。　処理件数は #{ExcelNyukinList.table_count(1)} 件です。"
                
                    # 入金仕入Excel_入金一覧の総合計の１行を更新
                    unless ExcelNyukinList.proc_syori3
                        alert = "入金仕入Excel_入金一覧の総合計の更新処理で、エラーが発生しました。"
                    end
                end
            end
        end

        # メッセージに改行を付ける
        notice = ""
        @msg.each_with_index do |val, idx|
            notice += ERB::Util.h("・ " + val)
            notice += "<br>" unless (@msg.length == idx + 1)
        end
        
        flash[:notice] = notice
        flash[:alert]  = alert
        
        redirect_to con37_nyushi_excels_url
    end

    # ---------------------------------------------------------
    # 入金仕入Excel_入金一覧 《Excel出力》
    # ---------------------------------------------------------
    def export_nyu

        # 入金仕入Excel_入金一覧の読み込み
        sql = "Select * From excel_nyukin_lists Order By seikyu_key_link"
        @ex_nyukin = ExcelNyukinList.find_by_sql(sql)
        
        if ( @ex_nyukin.size == 0 )
            flash[:alert]  = "入金一覧表のデータ件数が0件のため、ダウンロードできません。"
            redirect_to con37_nyushi_excels_url
            return
        end

        filename = "入金一覧表510_#{Time.current.strftime("%Y%m")}"

        respond_to do |format|
            format.xlsx do
                response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xlsx"
            end
        end
    end

    # ---------------------------------------------------------
    # 入金仕入Excel_仕入一覧 《CSV出力》
    # ---------------------------------------------------------
    def export_shi

        # 入金仕入Excel_仕入一覧の読み込み
        sql = "Select * From excel_shiire_lists Order by seikyu_key_link"
        @ex_shiire = ExcelShiireList.find_by_sql(sql)
        
        if ( @ex_shiire.size == 0 )
            flash[:alert]  = "仕入一覧表のデータ件数が0件のため、ダウンロードできません。"
            redirect_to con37_nyushi_excels_url
            return
        end

        filename = "仕入一覧表510_#{Date.today.strftime("%Y%m")}"

        respond_to do |format|
            format.csv do
                send_data ExcelShiireList.proc_csv(@ex_shiire), filename: "#{filename}.csv"
            end
        end
    end
end
