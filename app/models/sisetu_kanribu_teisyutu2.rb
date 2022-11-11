# 施設テーブル_管理部提出データ２
class SisetuKanribuTeisyutu2 < ApplicationRecord

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

            count = SisetuKanribuTeisyutu2
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
                    hash["id"]                   = row[0]
                    hash["shiire_nm"]            = row[1]
                    hash["uri_m"]                = row[2]
                    hash["siharai_kikan_cd"]     = row[3]
                    hash["seikyu_basho"]         = row[4]
                    hash["hakko_flg_seikyu_syo"] = row[5]
                    hash["print_flg"]            = row[6]
                    hash["hasu_kbn_seikyu_gaku"] = row[7]
                    hash["hasu_kbn_syouhizei"]   = row[8]
                    hash["id_user"]              = row[9]
                    
                    sisetu_kanribu_teisyutu2 = new
                    sisetu_kanribu_teisyutu2.attributes = hash
                    sisetu_kanribu_teisyutu2.save!
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
            connection.execute "TRUNCATE TABLE sisetu_kanribu_teisyutu2s;"
        end

        
    end
end
