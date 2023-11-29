class Con37NyushiExcelsController < ApplicationController

    def index

        @table1s = SisetuKanribuTeisyutu1.select(:id, :created_at).order(id: "DESC").limit(1)
        @table2s = SisetuKanribuTeisyutu2.select(:id, :created_at).order(id: "DESC").limit(1)
        @table0s = SisetuKanribuTeisyutu0.select(:id, :created_at).order(id: "DESC").limit(1)

        @tbl1_cnt = SisetuKanribuTeisyutu1.table_count(1)       # テーブル１のデータ件数を取得
        @tbl2_cnt = SisetuKanribuTeisyutu2.table_count(1)       # テーブル２のデータ件数を取得
        @tbl0_cnt = SisetuKanribuTeisyutu0.table_count(1)       # テーブル０のデータ件数を取得
    end

    # ---------------------------------------------------------
    # 楽楽からCSVファイル1 《インポート》
    # ---------------------------------------------------------
    def import1
        
        # ファイル取り込みのチェック
        ret, msg = Common.check_file(params[:file])
        flash[:alert]  = msg unless ret.zero?

        if ret.zero?
            if SisetuKanribuTeisyutu1.import_main(params[:file])
                flash[:notice] = "管理部提出データ出力１の取り込みが完了しました。　処理件数は #{SisetuKanribuTeisyutu1.table_count(1)} 件です。"
            else
                flash[:alert]  = "エラーが発生しました。"
            end
        end

        redirect_to con37_nyushi_excels_url
    end


    # ---------------------------------------------------------
    # 楽楽からCSVファイル2 《インポート》
    # ---------------------------------------------------------
    def import2

        # ファイル取り込みのチェック
        ret, msg = Common.check_file(params[:file])
        flash[:alert] = msg unless ret.zero?

        if ret.zero?
            if SisetuKanribuTeisyutu2.import_main(params[:file])
                flash[:notice] = "管理部提出データ出力２の取り込みが完了しました。　処理件数は #{SisetuKanribuTeisyutu2.table_count(1)} 件です。"
            else
                flash[:alert]  = "エラーが発生しました。"
            end
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
            alert  = "管理部提出データ出力１と２の結合処理で、エラーが発生しました。"
        else
            @msg << "「管理部提出データ出力テーブル１、２」の結合が完了しました。　処理件数は #{SisetuKanribuTeisyutu0.table_count(1)} 件です。"

            # 入金仕入Excel_仕入一覧の更新
            unless ExcelShiireList.proc_main
                alert  = "入金仕入Excel_仕入一覧の更新処理で、エラーが発生しました。"
            else
                @msg << "「入金仕入Excel_仕入一覧テーブル」の更新が完了しました。　　 処理件数は #{ExcelShiireList.table_count(1)} 件です。"

                # 入金仕入Excel_入金一覧の更新
                unless ExcelNyukinList.proc_main
                    alert  = "入金仕入Excel_入金一覧の更新処理で、エラーが発生しました。"
                else
                    @msg << "「入金仕入Excel_入金一覧テーブル」の更新が完了しました。　　 処理件数は #{ExcelNyukinList.table_count(1)} 件です。"
                
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

        sql = "Select * From excel_nyukin_lists Order By seikyu_key_link"
        @ex_nyukin = ExcelNyukinList.find_by_sql(sql)                       # 入金仕入Excel_入金一覧の読み込み
        
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
