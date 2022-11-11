# 入金仕入Excel_仕入一覧
class ExcelShiireList < ApplicationRecord

    class << self

        # ---------------------------------------------------------
        # 入金仕入Excel_仕入一覧の更新　≪メイン≫
        # ---------------------------------------------------------
        def proc_main

            table_delete            # 入金仕入Excel_仕入一覧の削除

            unless proc_syori1      # 入金仕入Excel_仕入一覧の更新
                return false
            end
            return true
        end

        # ---------------------------------------------------------
        # 入金仕入Excel_仕入一覧の更新
        # ---------------------------------------------------------
        def proc_syori1
            
            begin

                # 施設テーブル_管理部提出データ0_統合を読み込む
                # 今テストでこのような条件にしている
                # 後で復活させる @table0 = SisetuKanribuTeisyutu0.where("shiire_cd >= '0'")
                @table0 = SisetuKanribuTeisyutu0.where(print_flg: '有')
                                                .order(:seikyu_key_link)
                                                .order(:sisetu_cd) 

                retun true if ( @table0.size == 0 )
                    
                tanka_sum  = 0              # 単価の初期化
                assen_sum  = 0              # 斡旋手数料の初期化
                seiKeyLink = ""             # 請求キーリンクの初期化

                @table0.each_with_index do |table0, idx|

                    if ( idx > 0 )
                        if ( seiKeyLink == table0.seikyu_key_link )
                        else
                            unless proc_syori2(table0, assen_sum)   # 入金仕入Excel_仕入一覧の更新
                                return false
                            end

                            tanka_sum = 0                       # 単価の初期化
                            assen_sum = 0                       # 斡旋手数料の初期化
                        end
                    end

                    tanka_sum  += table0.tanka                  # 単価の合計
                    assen_sum  += table0.assen_tesuryo          # 斡旋手数料の合計
                    seiKeyLink  = table0.seikyu_key_link        # 請求キーリンクの退避

                    # 最終行
                    if ( idx == @table0.size - 1 )
                        unless proc_syori2(table0, assen_sum)   # 入金仕入Excel_仕入一覧の更新
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
        # 入金仕入Excel_仕入の更新
        # ---------------------------------------------------------
        def proc_syori2(table0, assen_sum)

            begin
                hash = {}
                hash["denpyo_kugiri"]   = "*"
                hash["hojyo_kamoku"]    = table0.shiire_cd
                hash["torihikisaki"]    = table0.shiire_nm
                hash["tekiyo1"]         = table0.seikyu_saki1
                hash["tekiyo2"]         = table0.uri_m.to_s + "月"
                hash["tekiyo3"]         = table0.seikyu_syo_naiyo_ue
                hash["biko"]            = table0.seikyu_saki1.to_s + " " + table0.uri_m.to_s + "月" + " " + table0.seikyu_syo_naiyo_ue.to_s
                hash["kingaku"]         = assen_sum
                hash["zei"]             = assen_sum * 0.1
                hash["bumon"]           = "510"
                hash["kasikata_kamoku"] = "6100"
                hash["syouhizei"]       = 10
                hash["gokei_kingaku"]   = assen_sum + (assen_sum * 0.1)
                hash["kaikake_kin"]     = "4050"
                hash["hizuke"]          = Time.current.strftime("%Y/%m") + "/01"
                hash["torihikisaki_c"]  = (Common.check_integer(table0.shiire_cd) + 4000).to_s
                hash["seikyu_key_link"] = table0.seikyu_key_link

                excel_shiire_list = new
                excel_shiire_list.attributes = hash
                excel_shiire_list.save!
                return true

            rescue => ex

                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end


        # ---------------------------------------------------------
        # CSVに出力
        # ---------------------------------------------------------
        def proc_csv(ex_shiire)

            CSV.generate( headers: true ) do |csv|

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

        

        # ---------------------------------------------------------
        # データ件数を取得
        # ---------------------------------------------------------
        def table_count(flg)

            count = ExcelShiireList
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
            connection.execute "TRUNCATE TABLE excel_shiire_lists;"
        end

        private :proc_syori1
        private :proc_syori2
        private :table_delete

    end
end
