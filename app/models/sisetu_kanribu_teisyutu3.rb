# 施設テーブル_管理部提出データ３
class SisetuKanribuTeisyutu3 < ApplicationRecord
    class << self

        # データを全件取得
        def table_select
            SisetuKanribuTeisyutu3.all.order(:id)
        end

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE sisetu_kanribu_teisyutu3s;"
        end
        
        # CSVファイルをインポート
        def table_import(file)

            begin
                err_id = ""

                CSV.foreach(file.path, headers: true) do |row|

                    break if row.size != 7

                    hash = {}
                    hash["id"], err_id      = row[1], row[1]
                    hash["update_raku"]     = Time.zone.parse(row[0])
                    hash["todoufuken"]      = row[2]
                    hash["shikutyouson"]    = row[3]
                    hash["kigyou"]          = row[4]
                    hash["seikyu_saki2"]    = row[5]
                    hash["bunrui"]          = row[6]

                    sisetu_kanribu_teisyutu3 = new
                    sisetu_kanribu_teisyutu3.attributes = hash
                    sisetu_kanribu_teisyutu3.save!
                end

                if table_count(0) == "0"
                    return false, "管理部提出データ出力３の取り込み元ファイルに誤りがあります。"
                end

                return true, "管理部提出データ出力３の取り込みが完了しました。　処理件数は #{table_count(1)} 件です。"

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "自動採番:" + err_id.to_s + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end
        
        # データ件数を取得
        def table_count(flg)

            count = SisetuKanribuTeisyutu3
            case flg
                when 0 then count.count.to_s
                when 1 then count.count.to_s(:delimited)
            end
        end
    end
end
