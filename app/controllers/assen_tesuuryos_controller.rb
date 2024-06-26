class AssenTesuuryosController < ApplicationController

    def index
    end

    # 実行
    def create

        ret, msg, msg_ary = nil, "", []
        time_measure = {str: 0, end: 0}

        catch(:goto_err) do

            # 時間計測の開始
            time_measure[:str] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

            # 請求年月の入力チェック
            ret = params[:txt_seikyu_ym].present?
            if !ret
                msg = "請求年月が空白です。"
                throw :goto_err
            end

            # テーブルを全件削除
            AssenSeikyu.table_delete

            # データを抽出
            ret, tbl, msg = SisetuKanribuTeisyutu0.table_select_assen
            throw :goto_err if !ret
            
            # データを更新
            ret, msg = AssenSeikyu.table_insert(tbl)
            throw :goto_err if !ret

            msg_ary << "斡旋手数料の請求書のデータ抽出が完了しました。　処理件数は #{AssenSeikyu.table_count(1)} 件です。"

            # Excelファイルの雛形にデータをセット
            ret, msg = create_excel
            throw :goto_err if !ret

            msg_ary << "Excelファイルの作成が完了しました。"

            # 時間計測の終了
            time_measure[:end] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

            measure_frm = time_measure[:end] - time_measure[:str] >= 60 ? "%M分%S秒" : "%S秒"
            measure_msg = Time.at(time_measure[:end] - time_measure[:str]).utc.strftime(measure_frm)

            msg_ary[-1] = msg_ary[-1] + "　（処理時間 #{measure_msg}）"
        end
        
        if ret
            notice = ""
            msg_ary.each_with_index do |val, idx|
                notice += ERB::Util.h("・ " + val)
                notice += "<br>" unless (msg_ary.length == idx + 1)
            end
            flash[:notice] = notice
        else
            flash[:alert]  = msg
        end
        
        redirect_to assen_tesuuryos_url(seikyu_ym: params[:txt_seikyu_ym])
    end
    
    # Excelダウンロード
    def export_assen
        
        ret, msg = nil, ""

        catch(:goto_err) do
            # ファイルの存在チェック
            ret, msg = Common.check_file_exist(@@assen_file_out)
            throw :goto_err if !ret
        end

        if !ret
            flash[:alert] = msg
            redirect_to assen_tesuuryos_url(seikyu_ym: params[:txt_seikyu_ym])
        else
            # Excelファイルのダウンロード
            send_file(@@assen_file_out)
        end
    end

    private

    # 斡旋手数料のExcelファイルを作成する処理
    def create_excel

        ret, msg = nil, ""

        catch(:goto_err) do

            # Excelファイルの存在チェック
            ret, msg = Common.check_file_exist(@@assen_file_mot)
            return false, msg if !ret
            
            # Excelファイルの事前バックアップ
            ret, msg = Common.check_file_copy(@@assen_file_mot)
            return false, msg if !ret

            # 斡旋手数料の請求書テーブルからデータを抽出
            table = AssenSeikyu.table_select

            # 斡旋手数料の請求書テーブルからExcelにデータを出力
            ret, msg = excel_update(table)
            return false, msg if !ret
        end
        return true, nil
    end

    # Excelにデータを出力
    # メモ：Excel上で金額計算の関数を書いてもRubyXLで出力すれば有効にならないことが判明
    def excel_update(table)
        
        begin
            err_id = ""                                     # エラーID
            key_break = ""                                  # キーブレイク条件
            kingaku, kingaku_sum, row_cnt = 0, 0, 0         # 金額、合計金額、明細行数
            col = {}                                        # Excelセルの開始列

            workbook = RubyXL::Parser.parse(@@assen_file_mot)
            sheet_names = workbook.worksheets.map(&:sheet_name)
            worksheet = workbook[""]

            table.each do |tbl|

                err_id = tbl.id
                
                # キーブレイク条件
                if key_break != tbl.shiire_nm
                    if key_break == "" then
                    else
                        # 合計を出力
                        2.times { |icnt|
                            # 合計金額
                            rs1 = worksheet.add_cell(col[:stcl] * icnt + 7, col[:head][:sum], "￥#{(kingaku_sum + (kingaku_sum * 0.1).to_i).to_s(:delimited)}")
                            rs1.change_font_size(12)
                            rs1.change_horizontal_alignment('center')
                            rs1.change_border(:top, 'thin')

                            # 課税対象額
                            rs2 = worksheet.add_cell(col[:stcl] * icnt + 9, col[:head][:sum], "￥#{kingaku_sum.to_s(:delimited)}")
                            rs2.change_horizontal_alignment('center')
                            rs2.change_border(:bottom, 'thin')

                            # 消費税額
                            rs3 = worksheet.add_cell(col[:stcl] * icnt + 10, col[:head][:sum], "￥#{(kingaku_sum * 0.1).to_i.to_s(:delimited)}")
                            rs3.change_horizontal_alignment('center')
                            rs3.change_border(:bottom, 'thin')
                        }

                        kingaku_sum, row_cnt = 0, 0
                        key_break = ""
                    end

                    # 初期設定（タグ名を取得）
                    hash_tag = {}
                    hash_tag = case tbl.shiire_nm
                            when "東日本支社"   then {tag_name: "請求書 (東日本)",      column: 11}
                            when "北関東支店"   then {tag_name: "請求書 (北関東)",      column: 11}
                            when "神奈川支店"   then {tag_name: "請求書 (神奈川)",      column: 11}
                            when "中部支社"     then {tag_name: "請求書 (中部)",        column: 11}
                            when "関西支社"     then {tag_name: "請求書 (関西)",        column: 23}
                            when "四国支店"     then {tag_name: "請求書 (関西・旧四国)", column: 11}
                            when "中国支店"     then {tag_name: "請求書 (中国)",        column: 23}
                            when "西日本支社"   then {tag_name: "請求書 (西日本)",      column: 11}
                          # when "北陸支店"     then {tag_name: "請求書 (北陸)",        column: 11}
                          # when "北東北支店"   then {tag_name: "請求書 (北東北)",      column: 11}
                          # when "長野支店"     then {tag_name: "請求書 (長野)",        column: 11}
                          # when "静岡支店"     then {tag_name: "請求書 (静岡)",        column: 11}
                            else next
                    end
                    
                    # テスト用
                    # if (tbl.shiire_nm == "四国支店" or tbl.shiire_nm == "中部支社" or tbl.shiire_nm == "関西支社")
                    # else
                    #     next
                    # end
                    
                    # 既存のExcelに指定のシートが存在するかチェック
                    next if !sheet_names.include?(hash_tag[:tag_name])
                    worksheet = workbook[hash_tag[:tag_name]]
                    
                    # 初期設定（開始列をセット）
                    col = {}
                    col = {stcl: 42, head: {yyy: 53, tiy: 36, siy: 3, sum: 31}, body: {kis: 6, kok: 16, ser: 30, tan: 39, suu: 47, kin: 52}} if hash_tag[:column] == 11     # 11明細
                    col = {stcl: 66, head: {yyy: 40, tiy: 29, siy: 1, sum: 24}, body: {kis: 4, kok: 12, ser: 25, tan: 32, suu: 37, kin: 42}} if hash_tag[:column] == 23     # 23明細

                    # ヘッダ情報を出力
                    2.times do |icnt| 
                        # ヘッダ部 － 年月日（右上）
                        rs1 = worksheet.add_cell(col[:stcl] * icnt + 0, col[:head][:yyy], Time.current.strftime("%Y"))
                        rs1.change_horizontal_alignment('center')
                        
                        # ヘッダ部 － タイトル年月（真ん中）
                        rs2 = worksheet.add_cell(col[:stcl] * icnt + 1, col[:head][:tiy], "#{params[:txt_seikyu_ym][0, 4]}年#{params[:txt_seikyu_ym][5, 2]}月分")
                        rs2.change_horizontal_alignment('center')
                        rs2.change_font_size(18)
                        rs2.change_font_bold(true)

                        # ヘッダ部 － 支払手数料種別（左中）
                        if icnt == 1
                            rs3 = worksheet.add_cell(col[:stcl] * icnt + 9, col[:head][:siy], "#{params[:txt_seikyu_ym][0, 4]}年#{params[:txt_seikyu_ym][5, 2]}月分")
                            rs3.change_horizontal_alignment('center')
                            rs3.change_border(:left, 'thin')
                        end
                    end
                end

                # 明細情報を出力
                2.times do |icnt|
                    if tbl.assen_tesuryo == 500
                        # 貴社拠点名
                        rs1 = worksheet.add_cell(col[:stcl] * icnt + 13 + row_cnt, col[:body][:kis], tbl.shiire_nm == "四国支店" ? "関西支社" : tbl.shiire_nm)
                        rs1.change_horizontal_alignment('center')
                        
                        # 顧客名
                        rs2 = worksheet.add_cell(col[:stcl] * icnt + 13 + row_cnt, col[:body][:kok], tbl.kokyaku)
                        rs2.change_horizontal_alignment('center')
                        rs2.change_border(:left, 'thin')
                        rs2.change_shrink_to_fit(true)
                    end
                
                    if tbl.suuryou != 0
                        # サービス名
                        rs1 = worksheet.add_cell(col[:stcl] * icnt + 13 + row_cnt, col[:body][:ser], "#{tbl.assen_tesuryo}円プラン")

                        # サービス名（罫線）
                        rs1.change_border(:bottom, 'hair') if tbl.assen_tesuryo == 500
                        rs1.change_border(:bottom, 'thin') if tbl.assen_tesuryo != 500

                        # 単価
                        rs2 = worksheet.add_cell(col[:stcl] * icnt + 13 + row_cnt, col[:body][:tan], tbl.assen_tesuryo)
                        rs2.set_number_format('#,##0')
                        
                        # 単価（罫線）
                        rs2.change_border(:bottom, 'hair') if tbl.assen_tesuryo == 500
                        rs2.change_border(:bottom, 'thin') if tbl.assen_tesuryo != 500

                        # 数量
                        rs3 = worksheet.add_cell(col[:stcl] * icnt + 13 + row_cnt, col[:body][:suu], tbl.suuryou)
                        rs3.set_number_format('#,##0')

                        # 数量（罫線）
                        rs3.change_border(:bottom, 'hair') if tbl.assen_tesuryo == 500
                        rs3.change_border(:bottom, 'thin') if tbl.assen_tesuryo != 500

                        kingaku = Common.check_integer(tbl.assen_tesuryo) * Common.check_integer(tbl.suuryou)
                        kingaku_sum = kingaku_sum + kingaku if icnt == 0

                        # 金額
                        rs4 = worksheet.add_cell(col[:stcl] * icnt + 13 + row_cnt, col[:body][:kin], kingaku)
                        rs4.set_number_format('#,###,##0')
                        
                        # 金額（罫線）
                        rs4.change_border(:bottom, 'hair') if tbl.assen_tesuryo == 500
                        rs4.change_border(:bottom, 'thin') if tbl.assen_tesuryo != 500
                    end
                end
                
                key_break = tbl.shiire_nm                   # キーブレイク条件のセット
                row_cnt += 1                                # 明細行カウントアップ

                # 最終行の処理
                if (table.size == tbl.id)
                    # 合計を出力
                    2.times do |icnt|
                        # 合計金額
                        rs1 = worksheet.add_cell(col[:stcl] * icnt + 7, col[:head][:sum], "￥#{(kingaku_sum + (kingaku_sum * 0.1).to_i).to_s(:delimited)}")
                        rs1.change_horizontal_alignment('center')
                        rs1.change_font_size(12)
                        rs1.change_border(:top, 'thin')

                        # 課税対象額
                        rs2 = worksheet.add_cell(col[:stcl] * icnt + 9, col[:head][:sum], "￥#{kingaku_sum.to_s(:delimited)}")
                        rs2.change_horizontal_alignment('center')
                        rs2.change_border(:bottom, 'thin')

                        # 消費税額
                        rs3 = worksheet.add_cell(col[:stcl] * icnt + 10, col[:head][:sum], "￥#{(kingaku_sum * 0.1).to_i.to_s(:delimited)}")
                        rs3.change_horizontal_alignment('center')
                        rs3.change_border(:bottom, 'thin')
                    end
                end
            end
            
            workbook.write(@@assen_file_out)
            return true, nil

        rescue => ex
            err = "assen_tesuuryos_controller." + __method__.to_s + " : " + ex.message
            err = err + " : " + "id:" + "#{err_id}" + "の更新でエラーが発生しています"
            @@debug.pri_logger.error(err)

            msg = if ex.message.include?("Text file busy")
                "書き込み先のExcelファイルが開かれています。ファイルを閉じてから処理を実行してください。"
            else
                "エラーが発生しました。"
            end
            return false, msg, nil
        end
    end

    # Rubyxlの出力テスト
    def test

        book  = RubyXL::Workbook.new
        sheet = book[0]
        
        sheet.add_cell(0, 0, 'hoge')
        aaa= 1111
        rs1 = sheet.add_cell(1, 0, "￥#{aaa}")

        rs1.set_number_format('##,###,##0')
        rs1.change_horizontal_alignment('center')
        rs1.change_border(:top, 'thin')

        rs = sheet.add_cell(10, 0, '2024/03/01')
        rs.set_number_format('yyyy/mm/dd')
        rs.change_border(:bottom, 'hair')
        rs.change_horizontal_alignment('center')
        
         sheet.add_cell(11, 0, '2024/04/01').instance_exec {
            set_number_format('yyyy/mm/dd')
            change_border(:bottom, 'hair')
            change_horizontal_alignment('center')
        }
        book.write('foo.xlsx')
    end
end
