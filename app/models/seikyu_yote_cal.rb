class SeikyuYoteCal < ApplicationRecord

    class << self

        # ---------------------------------------------------------
        # 請求予定額計算のメイン処理
        # ---------------------------------------------------------
        def proc_main(seikyu_ym)

            table_delete
            unless proc1(seikyu_ym)
                return false
            end
            return true
        end

        private

        # ---------------------------------------------------------
        # 請求月テーブル、請求予定額テーブルを１月単位で、１２月分作成
        # ---------------------------------------------------------
        def proc1(seikyu_ym)

            # 0 ～ 11の範囲
            12.times do |icnt|

                seikyu_ym_next = Time.local(seikyu_ym.split("-")[0], seikyu_ym.split("-")[1]).since(icnt.months).strftime("%Y-%m")  # 請求月の次月を計算

                return false unless SeikyuTukiCal.proc_main(seikyu_ym_next)             # 請求月計算のメイン処理

                return false unless proc2(icnt, seikyu_ym_next)                         # 請求予定額テーブルの更新
            end

            return true
        end
        
        # ---------------------------------------------------------
        # 請求予定額テーブルの更新
        # ---------------------------------------------------------
        def proc2(icnt, seikyu_ym)

            begin

                # 時間があったら、２テーブル間で、結合のテストを行ってみる

                # ---------------------------------------------------------
                # 管理部提出データ0_統合 + 請求月計算 （金額合計を計算）
                # ---------------------------------------------------------
                sql = ""
                sql += "Select "
                sql += "te0.id            As id, "
                sql += "te0.tanka         As tanka, "
                sql += "te0.assen_tesuryo As assen_tesuryo, "
                sql += "cal.seikyu_m_su   As seikyu_m_su, "
                sql += "cal.print_flg     As print_flg "
                sql += "From sisetu_kanribu_teisyutu0s As te0 "
                sql += "Left Join seikyu_tuki_cals AS cal On te0.id = cal.id "
                sql += "Where te0.print_flg = '有'"

                @ex_shiire = ExcelShiireList.find_by_sql(sql)

                if ( @ex_shiire.size == 0 )
                    return false
                end

                kingk_sum = 0
                asngk_sum = 0

                @ex_shiire.each do | shiire |

                    kingk_sum += Common.check_integer("#{shiire.tanka}") * Common.check_integer("#{shiire.seikyu_m_su}")    # 請求金額
                    asngk_sum += Common.check_integer("#{shiire.assen_tesuryo}")                                            # 斡旋手数料
                end
                
                # ---------------------------------------------------------
                # 請求予定額の更新
                # ---------------------------------------------------------
                sql  = ""
                sql += "Insert Into seikyu_yote_cals( "
                sql += "id,"
                sql += "seikyu_ym,"
                sql += "seikyu_kin,"
                sql += "assen_tesuryo"
                sql += " ) "
                sql += "Values ( "
                sql += "#{icnt + 1},"                                       # No
                sql += "#{Common.change_kara(seikyu_ym.gsub("-","/"))},"    # 請求年月
                sql += "#{kingk_sum},"                                      # 請求金額
                sql += "#{asngk_sum}"                                       # 斡旋手数料
                sql += " )"

                res = ActiveRecord::Base.connection.execute(sql)

                # メモ：Insert文で更新する時、text型は''で囲まないと更新されない、時間型、数値型は''で囲まないこと

                return true

            rescue => ex
                err = self.class.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # 請求予定額テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE seikyu_yote_cals;"
        end
    end
end
