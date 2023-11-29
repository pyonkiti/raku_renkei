# 施設テーブル_管理部提出データ２
class SisetuKanribuTeisyutu2 < ApplicationRecord

    class << self

        # ---------------------------------------------------------
        # ファイル取り込みのチェック
        # ---------------------------------------------------------
        def check_head(file)
            
            ret = Common.check_file(file)
            return ret
        end

        # ---------------------------------------------------------
        # メイン処理
        # ---------------------------------------------------------
        def import_main(file)
            
            table_delete
            unless table_import(file)
                return false
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
                err_id = ""
                CSV.foreach(file.path, headers: true) do |row|

                    hash = {}
                    hash["id"], err_id           = row[0], row[0]
                    hash["shiire_nm"]            = row[1]
                    hash["uri_m"]                = row[2]
                    hash["siharai_kikan_cd"]     = row[3]
                    hash["seikyu_basho"]         = row[4]
                    hash["hakko_flg_seikyu_syo"] = row[5]
                    hash["print_flg"]            = row[6]
                    hash["hasu_kbn_seikyu_gaku"] = row[7]
                    hash["hasu_kbn_syouhizei"]   = row[8]
                    hash["id_user"]              = row[9]
                    hash["nyukin_out_flg"]       = row[10]
                    sisetu_kanribu_teisyutu2 = new
                    sisetu_kanribu_teisyutu2.attributes = hash
                    sisetu_kanribu_teisyutu2.save!
                end
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "自動採番:" + err_id.to_s + "の更新でエラーが発生しています"
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
