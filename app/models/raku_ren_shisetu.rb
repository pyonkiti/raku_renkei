# 楽楽との連携（施設）
class RakuRenShisetu < ApplicationRecord
    class << self

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE raku_ren_shisetus;"
        end

        # CSVファイルをインポート
        def table_import(file)
            begin
                err_id, icnt = "", 1
                CSV.foreach(file.path, headers: true) do |row|

                    break if row.size != 5                                  # 施設のCSVファイル（引用元）のカラム数は5
                    hash = {}
                    hash["id"]              = icnt
                    hash["seikyu_keylink"]  = row[0]
                    hash["bango"]           = row[1]
                    hash["shisetu"]         = row[2]
                    hash["shisetu_cd"]      = Common.check_integer(row[3])
                    hash["userkey"]         = row[4]
                    err_id = "#{row[0]} - #{row[1]}"
                    icnt+=1

                    raku_ren_shisetu = new
                    raku_ren_shisetu.attributes = hash
                    raku_ren_shisetu.save!
                end

                if table_count(0) == "0"
                    return false, "Access連携出力（施設）の取り込み元ファイルに誤りがあります。"
                end

                return true, "Access連携出力（施設）の取り込みが完了しました。　処理件数は #{table_count(1)} 件です。"
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "請求キーリング－番号:" + err_id.to_s + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # データ件数を取得
        def table_count(flg)
            case flg
                when 0 then RakuRenShisetu.count.to_s
                when 1 then RakuRenShisetu.count.to_s(:delimited)
            end
        end
    end
end
