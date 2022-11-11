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
                # 施設テーブル_管理部提出データ0_統合を読み込む
                # 後で復活させる @table0 = SisetuKanribuTeisyutu0.where("shiire_cd >= '0'")
                @table0 = SisetuKanribuTeisyutu0.where(print_flg: '有')
                                                .order(:seikyu_key_link)
                                                .order(:sisetu_cd)

                return true if ( @table0.size == 0 )
                    
                tanka_sum  = 0              # 単価の初期化
                assen_sum  = 0              # 斡旋手数料の初期化
                seiKeyLink = ""             # 請求キーリンクの初期化

                @table0.each_with_index do |table0, idx|

                    if ( idx > 0 )
                        if ( seiKeyLink == table0.seikyu_key_link )
                        else
                            unless proc_syori2(table0, tanka_sum)   # 入金仕入Excel_入金一覧の更新
                                return false
                            end

                            tanka_sum = 0                           # 単価の初期化
                            assen_sum = 0                           # 斡旋手数料の初期化
                        end
                    end

                    tanka_sum  += table0.tanka                      # 単価の合計
                    assen_sum  += table0.assen_tesuryo              # 斡旋手数料の合計
                    seiKeyLink  = table0.seikyu_key_link            # 請求キーリンクの退避
                    
                    if ( idx == @table0.size - 1 )                  # 最終行
                        unless proc_syori2(table0, tanka_sum)       # 入金仕入Excel_入金一覧の更新
                            return false
                        end
                    end

                    next   if (idx == 5)          # テスト
                end
                return true

            rescue => ex

                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # 入金仕入Excel_入金の更新
        # ---------------------------------------------------------
        def proc_syori2(table0, tanka_sum)

            begin
                w_nyukin_ymd     = get_ymd( table0.siharai_yotei_kbn, table0.siharai_ymd_yokust, table0.siharai_ymd_yokued )    # 入金年月日
                w_kon_seikyu_kin = cal_hasuu( table0.hasu_kbn_seikyu_gaku, tanka_sum       )                                    # 今回請求金額
                w_kon_syouhizei  = cal_hasuu( table0.hasu_kbn_syouhizei,   tanka_sum * 0.1 )                                    # 今回消費税

                hash = {}
                hash["syodan_nm"]          = table0.seikyu_syo_naiyo_ue
                hash["seikyu_no"]          = ""
                hash["seikyu_ymd"]         = w_nyukin_ymd.delete("/")[0, 6] + "01"
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

                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
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
                    unless proc_syori4(ex_nyukin)                       # 入金仕入Excel_入金一覧の更新
                        return false
                    end
                end
                return true

            rescue => ex

                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
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
                hash["renban"]             = "総計"
                hash["edaban"]             = ""
                hash["yobi"]               = ""
                hash["seikyu_key_link"]    = "999999999"

                excel_nyukin_list = new
                excel_nyukin_list.attributes = hash
                excel_nyukin_list.save!
                return true

            rescue => ex

                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
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

            kingaku = Common.check_integer(kingaku)                # 数値の妥当性チェック

            case kbn
                when "四捨五入" then  kingaku.round
                when "切り上げ" then  kingaku.cell
                when "切り捨て" then  kingaku.floor
                else  kingaku.floor
            end
        end

        private :proc_syori1
        private :proc_syori2
        private :proc_syori4
        private :table_delete
        private :get_ymd
        private :cal_hasuu
    end
end
