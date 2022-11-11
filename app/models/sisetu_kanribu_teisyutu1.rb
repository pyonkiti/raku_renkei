# 施設テーブル_管理部提出データ１
class SisetuKanribuTeisyutu1 < ApplicationRecord

    class << self

        # ---------------------------------------------------------
        # メイン処理
        # ---------------------------------------------------------
        def import_main(file)

            if file.nil?
                return false
            else
                table_delete
                unless table_import(file)
                    return false
                end
            end
            return true
        end


        
        # ---------------------------------------------------------
        # データ件数を取得
        # ---------------------------------------------------------
        def table_count(flg)

            count = SisetuKanribuTeisyutu1
            case flg
                when 0
                    count.to_s
                when 1
                    count.count.to_s(:delimited)
            end
        end

    private

        # ---------------------------------------------------------
        # CSVファイルをインポート
        # ---------------------------------------------------------
        def table_import(file)

            begin
                CSV.foreach(file.path, headers: true) do |row|

                    hash = {}
                    hash["id"]                  = row[0]
                    hash["seikyu_key_link"]     = row[1]
                    hash["bango"]               = row[2]
                    hash["sisetu_cd"]           = Common.check_integer(row[3])
                    hash["sisetu_nm"]           = row[4]
                    hash["yuusyou_kaishi_ym"]   = row[5]
                    hash["yuusyou_syuryo_ym"]   = row[6]
                    hash["tanka"]               = Common.check_integer(row[7])
                    hash["assen_tesuryo"]       = Common.check_integer(row[8])
                    hash["seikyu_m_su"]         = Common.check_integer(row[9])
                    hash["seikyu_syo_naiyo_ue"] = row[10]
                    hash["tokuisaki_cd"]        = row[11]
                    hash["seikyu_saki1"]        = row[12]
                    hash["siharai_yotei_kbn"]   = row[13]
                    hash["siharai_ymd_yokust"]  = row[14]
                    hash["siharai_ymd_yokued"]  = row[15]
                    hash["ki"]                  = row[16]
                    hash["seikyu_m"]            = row[17]
                    hash["tantou_cd"]           = row[18]
                    hash["shiire_cd"]           = row[19]
                    
                    sisetu_kanribu_teisyutu1 = new
                    sisetu_kanribu_teisyutu1.attributes = hash
                    sisetu_kanribu_teisyutu1.save!
                end
                return true

            rescue => ex

                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE sisetu_kanribu_teisyutu1s;"
        end
    end
end
