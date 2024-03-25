# 施設テーブル_管理部提出データ0_統合
class SisetuKanribuTeisyutu0 < ApplicationRecord

    has_many :seikyu_tuki_cals              # 請求予定計算テーブル
    
    class << self

        # データ件数を取得
        def table_count(flg)
            count = SisetuKanribuTeisyutu0
            case flg
                when 0 then count.to_s
                when 1 then count.count.to_s(:delimited)
            end
        end

        # メイン処理
        def table_insert_main
            
            # 全件削除
            table_delete

            # テーブル1 ⇒ テーブル0に更新
            return false if !table_insert1
                
            # テーブル2 ⇒ テーブル0に更新
            return false if !table_insert2

            # テーブル3 ⇒ テーブル0に更新
            return false if !table_insert3

            return true
        end
        
        # 斡旋手数料の請求書の抽出用
        def table_select_assen
            begin
                # SisetuKanribuTeisyutu0からデータを抽出
                tbl = SisetuKanribuTeisyutu0
                        .where.not(shiire_nm: nil)
                        .where.not(shiire_nm: "")
                        .where.not(assen_tesuryo: 0)
                        .where(print_flg: '有')
                        .select(:shiire_nm, :kigyou, :seikyu_saki1, :seikyu_saki2, :assen_tesuryo)
                        .order(:shiire_nm, :seikyu_saki1)
                        
            return true, tbl, nil

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false, nil, "管理部提出データ（結合）のデータ抽出に失敗しました。"
            end
        end

    private

        # テーブル1 ⇒ テーブル0に更新
        def table_insert1
            
            begin
                # テーブル１の更新
                sql = ""
                sql += "Insert Into sisetu_kanribu_teisyutu0s("
                sql += SisetuKanribuTeisyutu1.table_colum1.join(",")
                sql += " ) "
                sql += " Select "
                sql += SisetuKanribuTeisyutu1.table_colum1.join(",")
                sql += " From sisetu_kanribu_teisyutu1s"

                res = ActiveRecord::Base.connection.execute(sql)
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # テーブル2 ⇒ テーブル0に更新
        def table_insert2
            
            begin
                err_id = ""
                
                # データを全件取得
                tbl = SisetuKanribuTeisyutu2.table_select
                
                tbl.each do |table2|

                    err_id = (table2.id).to_s

                    sql = ""
                    sql += "UPDATE sisetu_kanribu_teisyutu0s "
                    sql += "SET "
                    sql += "shiire_nm            = #{Common.change_kara(table2.shiire_nm)}, "
                    sql += "uri_m                = #{Common.change_kara(table2.uri_m)}, "
                    sql += "siharai_kikan_cd     = #{Common.change_kara(table2.siharai_kikan_cd)}, "
                    sql += "seikyu_basho         = #{Common.change_kara(table2.seikyu_basho)}, "
                    sql += "hakko_flg_seikyu_syo = #{Common.change_kara(table2.hakko_flg_seikyu_syo)}, "
                    sql += "print_flg            = #{Common.change_kara(table2.print_flg)}, "
                    sql += "hasu_kbn_seikyu_gaku = #{Common.change_kara(table2.hasu_kbn_seikyu_gaku)}, "
                    sql += "hasu_kbn_syouhizei   = #{Common.change_kara(table2.hasu_kbn_syouhizei)}, "
                    sql += "id_user              = #{Common.change_kara(table2.id_user)}, "
                    sql += "nyukin_out_flg       = #{Common.change_kara(table2.nyukin_out_flg)} "
                    sql += " WHERE id = " + (table2.id).to_s
                    
                    res = ActiveRecord::Base.connection.execute(sql)
                end
                return true
                
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id:" + err_id + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # テーブル3 ⇒ テーブル0に更新
        def table_insert3
            begin
                err_id = ""
                
                # データを全件取得
                tbl = SisetuKanribuTeisyutu3.table_select

                tbl.each do |table3|

                    err_id = (table3.id).to_s

                    sql = ""
                    sql += "UPDATE sisetu_kanribu_teisyutu0s "
                    sql += "SET "
                    sql += "todoufuken          = #{Common.change_kara(table3.todoufuken)}, "
                    sql += "shikutyouson        = #{Common.change_kara(table3.shikutyouson)}, "
                    sql += "kigyou              = #{Common.change_kara(table3.kigyou)}, "
                    sql += "seikyu_saki2        = #{Common.change_kara(table3.seikyu_saki2)}, "
                    sql += "created_at          = #{Common.change_kara(Time.current.ago(9.hours))} " 
                    sql += " WHERE id = " + (table3.id).to_s

                    res = ActiveRecord::Base.connection.execute(sql)
                end
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id:" + err_id + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE sisetu_kanribu_teisyutu0s CASCADE;"
        end
    end
end
