# 施設テーブル_管理部提出データ１
class SisetuKanribuTeisyutu1 < ApplicationRecord

    class << self

        # CSVファイルをインポート
        def table_import(file)

            begin
                err_id = ""
                CSV.foreach(file.path, headers: true) do |row|
                    
                    break if row.size != 21
                    
                    # ゴミデータは更新しない
                    next if row[2].to_s == ""

                    hash = {}
                    hash["id"], err_id          = row[1], row[1]
                    hash["update_raku"]         = Time.zone.parse(row[0])
                    hash["seikyu_key_link"]     = row[2]
                    hash["bango"]               = row[3]
                    hash["sisetu_cd"]           = Common.check_integer(row[4])
                    hash["sisetu_nm"]           = row[5]
                    hash["yuusyou_kaishi_ym"]   = row[6]
                    hash["yuusyou_syuryo_ym"]   = row[7]
                    hash["tanka"]               = Common.check_integer(row[8])
                    hash["assen_tesuryo"]       = Common.check_integer(row[9])
                    hash["seikyu_m_su"]         = Common.check_integer(row[10])
                    hash["seikyu_syo_naiyo_ue"] = row[11]
                    hash["tokuisaki_cd"]        = row[12]
                    hash["seikyu_saki1"]        = row[13]
                    hash["siharai_yotei_kbn"]   = row[14]
                    hash["siharai_ymd_yokust"]  = row[15]
                    hash["siharai_ymd_yokued"]  = row[16]
                    hash["ki"]                  = row[17]
                    hash["seikyu_m"]            = row[18]
                    hash["tantou_cd"]           = row[19]
                    hash["shiire_cd"]           = row[20]
                    
                    sisetu_kanribu_teisyutu1 = new
                    sisetu_kanribu_teisyutu1.attributes = hash
                    sisetu_kanribu_teisyutu1.save!
                end

                if table_count(0) == "0"
                    return false, "管理部提出データ出力１の取り込み元ファイルに誤りがあります。"
                end

                return true, "管理部提出データ出力１の取り込みが完了しました。　処理件数は #{table_count(1)} 件です。"

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "自動採番:" + err_id.to_s + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # データ件数を取得
        def table_count(flg)

            count = SisetuKanribuTeisyutu1
            case flg
                when 0 then count.count.to_s
                when 1 then count.count.to_s(:delimited)
            end
        end

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE sisetu_kanribu_teisyutu1s;"
        end

        # sisetu_kanribu_teisyutu1sの全カラム
        def table_colum1
            ["id",
             "update_raku",
             "seikyu_key_link",
             "bango",
             "sisetu_cd", 
             "sisetu_nm",
             "yuusyou_kaishi_ym",
             "yuusyou_syuryo_ym",
             "tanka", 
             "assen_tesuryo", 
             "seikyu_m_su", 
             "seikyu_syo_naiyo_ue",
             "tokuisaki_cd",
             "seikyu_saki1",
             "siharai_yotei_kbn",
             "siharai_ymd_yokust",
             "siharai_ymd_yokued",
             "ki",
             "seikyu_m",
             "tantou_cd",
             "shiire_cd"]
        end
    end
end
