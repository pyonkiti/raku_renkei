# 入金仕入Excel_仕入一覧
class ExcelShiireList < ApplicationRecord

    class << self

        # 入金仕入Excel_仕入一覧の更新　≪メイン≫
        def proc_main(chk_zengetu)

            @chk_zengetu = chk_zengetu                                  # 前月として実行チェック

            table_delete                                                # 入金仕入Excel_仕入一覧の削除
            return false if !proc_syori1                                # 入金仕入Excel_仕入一覧の更新
            return true
        end

        # 入金仕入Excel_仕入一覧の更新
        def proc_syori1
            
            begin
                # 施設テーブル_管理部提出データ0_統合を読み込む
                @table0 = SisetuKanribuTeisyutu0.where("shiire_cd >= '0'")
                                                .where(print_flg: '有')
                                                .order(:seikyu_key_link)
                                                .order(:sisetu_cd) 
                
                return true if ( @table0.size == 0 )

                err_seikyu_key_link = ""                                # 初期化：請求キーリンク
                assen_sum           = 0                                 # 初期化：斡旋手数料
                cnt                 = 0                                 # 件　数：ループ

                @table0.each_cons(2) do |table0, table_nxt|
                    
                    err_seikyu_key_link  = table0.seikyu_key_link       # エラー：請求キーリンク
                    assen_sum           += table0.assen_tesuryo         # 合　計：斡旋手数料
                    cnt                 += 1                            # 件　数：ループ

                    if ( table0.seikyu_key_link == table_nxt.seikyu_key_link )
                    else
                        unless proc_syori2(table0, assen_sum)           # 更新：入金仕入Excel_仕入一覧
                            return false
                        end
                        assen_sum = 0                                   # 初期化：斡旋手数料
                    end

                    # 最終行
                    if ( cnt == @table0.size - 1 )
                        assen_sum  += table_nxt.assen_tesuryo           # 合計：斡旋手数料
                        unless proc_syori2(table_nxt, assen_sum)        # 更新：入金仕入Excel_仕入一覧
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

        # 入金仕入Excel_仕入の更新
        def proc_syori2(table0, assen_sum)

            begin
                err_seikyu_key_link = table0.seikyu_key_link

                hash = {}
                hash["denpyo_kugiri"]   = "*"
                hash["hojyo_kamoku"]    = table0.shiire_cd
                hash["torihikisaki"]    = table0.shiire_nm.split[0]
                shiire_nm_shiten = table0.shiire_nm.split[1].nil? ? "" : table0.shiire_nm.split[1]
                hash["tekiyo1"]         = shiire_nm_shiten
                hash["tekiyo2"]         = table0.uri_m.to_s + "月分"
                hash["tekiyo3"]         = "斡旋手数料"
                hash["biko"]            = shiire_nm_shiten + " " + table0.uri_m.to_s + "月分" + " " + "斡旋手数料"
                hash["kingaku"]         = assen_sum
                hash["zei"]             = assen_sum * 0.1
                hash["bumon"]           = "510"
                hash["kasikata_kamoku"] = "6100"
                hash["syouhizei"]       = 10
                hash["gokei_kingaku"]   = assen_sum + (assen_sum * 0.1)
                hash["kaikake_kin"]     = "4050"
                ym = @chk_zengetu? Time.current.prev_month.strftime("%Y/%m") : Time.current.strftime("%Y/%m")
                hash["hizuke"]          = Time.current.strftime(ym) + "/01"
                hash["torihikisaki_c"]  = (Common.check_integer(table0.shiire_cd) + 4000).to_s
                hash["seikyu_key_link"] = table0.seikyu_key_link

                excel_shiire_list = new
                excel_shiire_list.attributes = hash
                excel_shiire_list.save!
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "請求キーリンク:" + err_seikyu_key_link + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # CSVに出力
        def proc_csv(ex_shiire)

            CSV.generate( headers: true, force_quotes: true ) do |csv|

                csv << %w(伝票区切 補助科目 取引先 適用（１） 適用（２） 適用（３） 備考 金額 税 部門 借方科目 消費税 合計金額 買掛金 日付 取引先C)

                ex_shiire.each do |shiire|
                    arry = ["denpyo_kugiri", 
                            "hojyo_kamoku",
                            "torihikisaki",
                            "tekiyo1",
                            "tekiyo2",
                            "tekiyo3",
                            "biko",
                            "kingaku",
                            "zei",
                            "bumon",
                            "kasikata_kamoku",
                            "syouhizei",
                            "gokei_kingaku",
                            "kaikake_kin",
                            "hizuke",
                            "torihikisaki_c"]
                    csv << arry.map { |var| shiire.send(var) }
                end
            end
        end
        
        # データ件数を取得
        def table_count(flg)

            count = ExcelShiireList
            case flg
                when 0 then count.count.to_s
                when 1 then count.count.to_s(:delimited)
            end
        end

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE excel_shiire_lists;"
        end

        private :proc_syori1
        private :proc_syori2
        private :table_delete
    end
end
