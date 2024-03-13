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

                return false unless SeikyuTukiCal.proc_main(icnt, seikyu_ym_next)       # 請求月計算のメイン処理
                
                return false unless proc2(icnt, seikyu_ym_next)                         # 請求予定額テーブルの更新
            end
            return true
        end

        # ---------------------------------------------------------
        # 請求予定額テーブルの更新
        # ---------------------------------------------------------
        def proc2(icnt, seikyu_ym)

            begin
                # sql = ""
                # sql += "Select "
                # sql += "te0.id            As id, "
                # sql += "te0.tanka         As tanka, "
                # sql += "te0.assen_tesuryo As assen_tesuryo, "
                # sql += "cal.seikyu_m_su   As seikyu_m_su, "
                # sql += "cal.print_flg     As print_flg "
                # sql += "From sisetu_kanribu_teisyutu0s As te0 "
                # sql += "Left Join seikyu_tuki_cals AS cal On te0.id = cal.id "
                # sql += "Where cal.print_flg = '有' "
                # sql += "Order by te0.id"
                # ex_shiire = SisetuKanribuTeisyutu0.find_by_sql(sql)

                # ---------------------------------------------------------
                # 管理部提出データ0_統合 + 請求月計算 （金額合計を計算）
                # ---------------------------------------------------------
                ex_shiire = SisetuKanribuTeisyutu0.left_joins(:seikyu_tuki_cals)
                                .includes(:seikyu_tuki_cals)
                                .where(siharai_kikan_cd: get_jyoken_siharai(seikyu_ym))
                                .where("seikyu_tuki_cals.print_flg = '有'")
                                .where("seikyu_tuki_cals.seikyu_ym = '#{seikyu_ym.delete("-")}'")
                                .select("sisetu_kanribu_teisyutu0s.id As id")
                                .select("sisetu_kanribu_teisyutu0s.tanka As tanka")
                                .select("sisetu_kanribu_teisyutu0s.assen_tesuryo As assen_tesuryo")
                                .select("seikyu_tuki_cals.seikyu_m_su As seikyu_m_su")
                                .select("seikyu_tuki_cals.print_flg As print_flg")
                                .order("sisetu_kanribu_teisyutu0s.id")
                
                return false if ( ex_shiire.size == 0 )
                    
                # @@debug.pri_logger.error(ex_shiire.to_sql)

                kingk_sum = 0
                asngk_sum = 0

                ex_shiire.each do | shiire |
                    kingk_sum += Common.check_integer("#{shiire.tanka}") * Common.check_integer("#{shiire.seikyu_m_su}")    # 請求金額
                    asngk_sum += Common.check_integer("#{shiire.assen_tesuryo}")                                            # 斡旋手数料
                end
                
                # ---------------------------------------------------------
                # 請求予定額の更新
                # メモ：Insert文で更新する時、text型は''で囲まないと更新されない、時間型、数値型は''で囲まないこと
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

                return true
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # ActiveRecordからSQL文を生成
        # ---------------------------------------------------------
        # 不要であれば削除する
        def get_sql(seikyu_ym)

            sql = SisetuKanribuTeisyutu0.left_joins(:seikyu_tuki_cals)
                                        .includes(:seikyu_tuki_cals)
                                        .where("seikyu_tuki_cals.print_flg = '有'")
                                        .where("seikyu_tuki_cals.seikyu_ym = '#{seikyu_ym.delete("-")}'")
                                        .where("sisetu_kanribu_teisyutu0s.siharai_kikan_cd: #{get_jyoken_siharai(seikyu_ym)}")
                                        .select("sisetu_kanribu_teisyutu0s.id As id")
                                        .select("sisetu_kanribu_teisyutu0s.tanka As tanka")
                                        .select("sisetu_kanribu_teisyutu0s.assen_tesuryo As assen_tesuryo")
                                        .select("sisetu_kanribu_teisyutu0s.seikyu_m_su As seikyu_m_su_test")
                                        .select("seikyu_tuki_cals.seikyu_m_su As seikyu_m_su")
                                        .select("seikyu_tuki_cals.print_flg As print_flg")
                                        .order("seikyu_tuki_cals.id")
                                        .to_sql
            return sql
        end

        # ---------------------------------------------------------
        # 請求予定額テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE seikyu_yote_cals;"
        end

        # 
        def get_jyoken_siharai(seikyu_ym)

            res = case seikyu_ym.split("-")[1]
                when "01" then ["01"]
                when "02" then ["01", "12"]
                when "03" then ["01", "11", "21"]
                when "04" then ["01", "13"]
                when "05" then ["01"]
                when "06" then ["01"]
                when "07" then ["01"]
                when "08" then ["01", "12"]
                when "09" then ["01", "11"]
                when "10" then ["01", "13"]
                when "11" then ["01"]
                when "12" then ["01"]
                else ["01", "11", "12", "13", "21"]
            end
            return res
        end
        
        private :get_jyoken_siharai
    end
end
