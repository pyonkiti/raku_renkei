# 入金仕入Excel_入金一覧
class ExcelNyukinList < ApplicationRecord
    class << self
        
        # ---------------------------------------------------------
        # 入金仕入Excel_入金一覧の更新  ≪メイン≫
        # ---------------------------------------------------------
        def proc_main

            table_delete            # 入金仕入Excel_入金一覧の削除
            unless proc_syori1      # 入金仕入Excel_入金一覧の更新
                return false
            end
            return true
        end

        # ---------------------------------------------------------
        # 入金仕入Excel_入金一覧の更新
        # ---------------------------------------------------------
        def proc_syori1
            
            begin

                ary_shiire = get_siharai(Time.current.strftime("%m"))           # 支払期間コードを取得
                
                # 施設テーブル_管理部提出データ0_統合を読み込む
                @table0 = SisetuKanribuTeisyutu0.where(print_flg: '有')
                                                .where(siharai_kikan_cd: ary_shiire)
                                                .order(:seikyu_key_link)
                                                .order(:sisetu_cd)

                return true if ( @table0.size == 0 )
                
                err_seikyu_key_link = ""                                        # 初期化：請求キーリンク
                tanka_sum           = 0                                         # 初期化：単価
                cnt                 = 0                                         # 件数：ループ

                @table0.each_cons(2) do |table0, table_nxt|
                    
                    err_seikyu_key_link  = table0.seikyu_key_link                                                           # エラー：請求キーリンク
                    tanka_sum           += Common.check_integer(table0.tanka) * Common.check_integer(table0.seikyu_m_su)    # 合計：単価×請求月数
                    cnt                 += 1                                                                                # 件数：ループ

                    if ( table0.seikyu_key_link == table_nxt.seikyu_key_link )
                    else
                        unless proc_syori2(table0, tanka_sum)                   # 更新：入金仕入Excel_入金一覧
                            return false
                        end
                        tanka_sum = 0                                           # 初期化：単価
                    end
                    
                    # 最終行
                    if ( cnt == @table0.size - 1 )

                        tanka_sum  += Common.check_integer(table_nxt.tanka) * Common.check_integer(table_nxt.seikyu_m_su)   # 合計：単価×請求月数
                        unless proc_syori2(table_nxt, tanka_sum)                                                            # 更新：入金仕入Excel_入金一覧
                            return false
                        end
                    end
                end
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "請求キーリンク:" + err_seikyu_key_link + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # 入金仕入Excel_入金の更新
        # ---------------------------------------------------------
        def proc_syori2(table0, tanka_sum)

            require 'date'

            begin
                w_nyukin_ymd        = get_ymd( table0.siharai_yotei_kbn, table0.siharai_ymd_yokust, table0.siharai_ymd_yokued ) # 入金年月日
                w_kon_seikyu_kin    = cal_hasuu( table0.hasu_kbn_seikyu_gaku, tanka_sum       )                                 # 今回請求金額
                w_kon_syouhizei     = cal_hasuu( table0.hasu_kbn_syouhizei,   tanka_sum * 0.1 )                                 # 今回消費税

                err_seikyu_key_link = table0.seikyu_key_link
                ret = get_bun(table0.siharai_kikan_cd, Time.current.strftime("%Y-%m"))                                          # 何月分かの名称を取得

                hash = {}
                hash["syodan_nm"]          = table0.seikyu_syo_naiyo_ue.to_s + " " + ret
                hash["seikyu_no"]          = ""
              # hash["seikyu_ymd"]         = w_nyukin_ymd == "" ? "" : w_nyukin_ymd.delete("/")[0, 6] + "01"
                hash["seikyu_ymd"]         = w_nyukin_ymd == "" ? "" : Date.parse(w_nyukin_ymd.slice(0, 7) + "/01").prev_day(1).to_s.delete("-")    # 入金年月日の翌月末
                hash["torihikisaki_cd"]    = table0.tokuisaki_cd
                hash["seikyusaki_cd"]      = ""
                hash["seikyusaki_nm"]      = table0.seikyu_saki1
                hash["nyukin_ymd"]         = w_nyukin_ymd.delete("/")
                hash["nyukin_m"]           = w_nyukin_ymd.delete("/")[0, 6]
                hash["kon_seikyu_kin"]     = w_kon_seikyu_kin
                hash["kon_syouhizei"]      = w_kon_syouhizei
                hash["zeikomi_seikyu_kin"] = w_kon_seikyu_kin.to_i + w_kon_syouhizei.to_i
                hash["ki"]                 = table0.ki
                hash["bumon"]              = "510"
                hash["seikyu_m"]           = table0.seikyu_m
                hash["tantou"]             = table0.tantou_cd
                hash["renban"]             = ""
                hash["edaban"]             = ""
                hash["yobi"]               = ""
                hash["seikyu_key_link"]    = table0.seikyu_key_link

                excel_nyukin_list = new
                excel_nyukin_list.attributes = hash
                excel_nyukin_list.save!
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "請求キーリンク:" + err_seikyu_key_link + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false
            end
        end
        
        # ---------------------------------------------------------
        # 入金仕入Excel_入金一覧の総合計を１行だけ更新（メイン）
        # ---------------------------------------------------------
        def proc_syori3

            begin
                # 入金仕入Excel_入金一覧の集計
                sql  = "SUM(kon_seikyu_kin)     AS kon_seikyu_kin, "
                sql += "SUM(kon_syouhizei)      AS kon_syouhizei, "
                sql += "SUM(zeikomi_seikyu_kin) AS zeikomi_seikyu_kin "
                @ex_nyukin = ExcelNyukinList.all.select(sql)

                if ( @ex_nyukin.size == 0 )
                    return false
                end

                @ex_nyukin.each_with_index do |ex_nyukin, idx|
                    unless proc_syori4(ex_nyukin)                       # 更新：入金仕入Excel_入金一覧
                        return false
                    end
                end
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # 入金仕入Excel_入金一覧の総合計を１行だけ更新
        # ---------------------------------------------------------
        def proc_syori4(ex_nyukin)
            
            begin
                hash = {}
                hash["syodan_nm"]          = ""
                hash["seikyu_no"]          = ""
                hash["seikyu_ymd"]         = ""
                hash["torihikisaki_cd"]    = ""
                hash["seikyusaki_cd"]      = ""
                hash["seikyusaki_nm"]      = ""
                hash["nyukin_ymd"]         = ""
                hash["nyukin_m"]           = ""
                hash["kon_seikyu_kin"]     = ex_nyukin.kon_seikyu_kin
                hash["kon_syouhizei"]      = ex_nyukin.kon_syouhizei
                hash["zeikomi_seikyu_kin"] = ex_nyukin.zeikomi_seikyu_kin
                hash["ki"]                 = ""
                hash["bumon"]              = ""
                hash["seikyu_m"]           = ""
                hash["tantou"]             = ""
                hash["renban"]             = ""
                hash["edaban"]             = "総計"
                hash["yobi"]               = ""
                hash["seikyu_key_link"]    = "999999999"

                excel_nyukin_list = new
                excel_nyukin_list.attributes = hash
                excel_nyukin_list.save!
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # データ件数を取得
        # ---------------------------------------------------------
        def table_count(flg)

            count = ExcelNyukinList
            case flg
                when 0
                    count.to_s
                when 1
                    count.count.to_s(:delimited)
            end
        end

        # ---------------------------------------------------------
        # テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE excel_nyukin_lists;"
        end

        # ---------------------------------------------------------
        # 支払予定日区分から、支払日（翌月初）or支払日（翌月末）を判断する
        # ---------------------------------------------------------
        def get_ymd(kbn, *data)
 
            ret = case kbn
                when "翌月初" then data[0]
                when "翌月末" then data[1]
                else ""
            end
            return ret
        end

        # ---------------------------------------------------------
        # 端数区分より、請求額or消費税額の端数処理を行う
        # ---------------------------------------------------------
        def cal_hasuu(kbn, kingaku)
            case kbn
                when "四捨五入" then  kingaku.round
                when "切り上げ" then  kingaku.ceil
                when "切り捨て" then  kingaku.floor
                else  kingaku.floor
            end
        end

        # ---------------------------------------------------------
        # 支払期間コードの抽出条件をSQLで取得
        # ---------------------------------------------------------
        def get_siharai(mm)

            ret = case mm.to_i
                when  1 then ['01']
                when  2 then ['01','12']
                when  3 then ['01','11','21']
                when  4 then ['01','13']
                when  5 then ['01']
                when  6 then ['01']
                when  7 then ['01']
                when  8 then ['01','12']
                when  9 then ['01','11']
                when 10 then ['01','13']
                when 11 then ['01']
                when 12 then ['01']
                else []
            end
            return ret
        end

        # ---------------------------------------------------------
        # 何月分かの名称を取得
        # ---------------------------------------------------------
        def get_bun(siharai_kikan_cd, ym)

            yy = ym.split('-')[0].to_i                      # 年を取得
            mm = ym.split('-')[1].to_i                      # 月を取得

            case siharai_kikan_cd
                when "01" then "#{mm.to_s}月分"             # 毎月
                    
                when "11" then                              # 半期（9月/3月）
                    case mm
                        when 9 then "上期分"
                        when 3 then "下期分"
                        else ""
                    end
                    
                when "12" then                              # 半期（8月/2月）
                    case mm
                        when 8 then "上期分"
                        when 2 then "下期分"
                        else ""
                    end
                
                when "13" then                              # 半期（4月/10月）
                    case mm
                        when  4 then "上期分"
                        when 10 then "下期分"
                        else ""
                    end
                
                when "21" then "#{(yy - 1).to_s}年度分"     # 年度末（3月）
                else ""
            end
        end

        private :proc_syori1
        private :proc_syori2
        private :proc_syori4
        private :table_delete
        private :get_ymd
        private :cal_hasuu
        private :get_siharai
        private :get_bun
    end
end
