# 斡旋手数料の請求書
class AssenSeikyu < ApplicationRecord
    class << self

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE assen_seikyus;"
        end

        # データを更新
        def table_insert(table)

            begin
                # 初期値を設定
                keybrk = {}
                cnt_id = 1
                cnt_500, cnt_1000 = 0, 0

                table.each_with_index do |tbl, idx|
                    
                    tbl.kigyou.to_s.strip!
                    tbl.seikyu_saki1.to_s.strip!
                    tbl.seikyu_saki2.to_s.strip!
                    tbl.shiire_nm.to_s.gsub!(/ＮＥＣプラットフォームズ株式会社/, "").strip!

                    kokyaku = if tbl.kigyou == ""
                                tbl.seikyu_saki1
                            else
                                if (tbl.seikyu_saki1 != "" and tbl.seikyu_saki2 != "")
                                    tbl.seikyu_saki2
                                else
                                    tbl.seikyu_saki1
                                end
                            end

                    if idx > 0
                        # キーブレイク条件
                        if (keybrk["shiire_nm"] != tbl.shiire_nm or keybrk["kokyaku"] != kokyaku)
                            2.times do |idx|
                                hash = {}
                                hash["id"]              = cnt_id
                                hash["shiire_nm"]       = keybrk["shiire_nm"]
                                hash["kokyaku"]         = keybrk["kokyaku"]
                                hash["assen_tesuryo"]   = idx == 0 ? 500 : 1000
                                hash["suuryou"]         = idx == 0 ? cnt_500 : cnt_1000

                                assen_seikyu = new
                                assen_seikyu.attributes = hash
                                assen_seikyu.save!
                                cnt_id += 1
                            end
                            cnt_500, cnt_1000 = 0, 0
                        end
                    end
                    
                    # ブレイクキーをセット：仕入名
                    keybrk["shiire_nm"] = tbl.shiire_nm

                    # ブレイクキーをセット：顧客名
                    keybrk["kokyaku"] = kokyaku
                    
                    cnt_500  += 1 if tbl.assen_tesuryo.to_i == 500
                    cnt_1000 += 1 if tbl.assen_tesuryo.to_i == 1000

                    # 最終行の更新
                    if (idx == table.size - 1)
                        2.times do |idx|
                            hash = {}
                            hash["id"]              = cnt_id
                            hash["shiire_nm"]       = keybrk["shiire_nm"]
                            hash["kokyaku"]         = keybrk["kokyaku"]
                            hash["assen_tesuryo"]   = idx == 0 ? 500 : 1000
                            hash["suuryou"]         = idx == 0 ? cnt_500 : cnt_1000

                            assen_seikyu = new
                            assen_seikyu.attributes = hash
                            assen_seikyu.save!
                            cnt_id += 1
                        end
                    end
                end
                return true, nil

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id:" + cnt_id.to_s + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "斡旋手数料の請求書テーブルの更新でエラーが発生しました。"
            end
        end

        # データを検索
        def table_select
            AssenSeikyu.all.order(:id)
        end

        # データ件数を取得
        def table_count(flg)
            case flg
                when 0 then AssenSeikyu.count.to_s
                when 1 then AssenSeikyu.count.to_s(:delimited)
            end
        end
    end
end
