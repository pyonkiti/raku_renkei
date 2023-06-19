# 施設テーブル_管理部提出データ0_統合
class SisetuKanribuTeisyutu0 < ApplicationRecord

    has_many :seikyu_tuki_cals              # 請求予定計算テーブル
    
    class << self

        # ---------------------------------------------------------
        # データ件数を取得
        # ---------------------------------------------------------
        def table_count(flg)

            count = SisetuKanribuTeisyutu0
            case flg
                when 0
                    count.to_s
                when 1
                    count.count.to_s(:delimited)
            end
        end

        # ---------------------------------------------------------
        # メイン処理
        # ---------------------------------------------------------
        def table_insert_main
            
            table_delete
            unless table_insert1
                return false
            end
            unless table_insert2
                return false
            end
            return true
        end
        
    private

        # ---------------------------------------------------------
        # テーブル1 ⇒ テーブル0に更新
        # ---------------------------------------------------------
        def table_insert1
            
            begin
                # テーブル１の更新
                sql = ""
                sql += "Insert Into sisetu_kanribu_teisyutu0s("
                sql += table_colum1.join(",")
                sql += " ) "
                sql += " Select "
                sql += table_colum1.join(",")
                sql += " From sisetu_kanribu_teisyutu1s"

                res = ActiveRecord::Base.connection.execute(sql)
                return true

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                @@debug.pri_logger.error(err)
                return false
            end
        end

        # ---------------------------------------------------------
        # テーブル2 ⇒ テーブル0に更新
        # ---------------------------------------------------------
        def table_insert2
            
            begin
                err_id = ""
                @table2 = SisetuKanribuTeisyutu2.all.order(:id)

                @table2.each do |table2|

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
                    sql += "created_at           = #{Common.change_kara(Time.current.ago(9.hours))} " 
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

        # ---------------------------------------------------------
        # テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE sisetu_kanribu_teisyutu0s;"
        end

        # ---------------------------------------------------------
        # sisetu_kanribu_teisyutu1sの全カラム
        # ---------------------------------------------------------
        def table_colum1

            ["id",
             "seikyu_key_link",
             "bango",
             "sisetu_cd", 
             "sisetu_nm",
             "yuusyou_kaishi_ym",
             "yuusyou_syuryo_ym",
             "tanka", 
             "assen_tesuryo", 
             "seikyu_m_su", 
             "seikyu_syo_naiyo_ue",
             "tokuisaki_cd",
             "seikyu_saki1",
             "siharai_yotei_kbn",
             "siharai_ymd_yokust",
             "siharai_ymd_yokued",
             "ki",
             "seikyu_m",
             "tantou_cd",
             "shiire_cd"]
        end
    end
end
