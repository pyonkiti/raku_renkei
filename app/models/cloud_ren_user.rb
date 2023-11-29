class CloudRenUser < ApplicationRecord

    class << self
    
        # ---------------------------------------------------------
        # テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE cloud_ren_users CASCADE;"
        end

        # ---------------------------------------------------------
        # Sofinet CloudのWebAPI取得（ユーザーデータ取得）
        # ---------------------------------------------------------
        def table_insert

            begin
                err_id = ""
                url = "https://www.sofinetcloud.net/api/system/get_userkeys"
                respon = Net::HTTP.get_response(URI.parse(url))
                result = JSON.parse(respon.body)
                
                result.each_with_index do |res, icnt|
                    
                    err_id = "#{res["userkey"]}"
                    sql  = ""
                    sql += "Insert Into cloud_ren_users( "
                    sql += "id,"
                    sql += "userkey,"
                    sql += "pseudokey,"
                    sql += "remark,"
                    sql += "db_ip,"
                    sql += "port,"
                    sql += "almrcv_port,"
                    sql += "command_port,"
                    sql += "created_at"
                    sql += " ) "
                    sql += "Values ( "
                    sql += "#{icnt + 1},"                                       # id
                    sql += "#{Common.change_kara(res["userkey"])},"
                    sql += "#{Common.change_kara(res["pseudokey"])},"
                    sql += "#{Common.change_kara(res["remark"])},"
                    sql += "#{Common.change_kara(res["db_ip"])},"
                    sql += "#{Common.change_kara(res["port"])},"
                    sql += "#{Common.change_kara(res["almrcv_port"])},"
                    sql += "#{Common.change_kara(res["command_port"])},"
                    sql += "#{Common.change_kara(Time.current)}"
                    sql += " )"
                    ret = ActiveRecord::Base.connection.execute(sql)

                    # @@debug.pri_logger.error("#{sql}")
                    # @@debug.pri_logger.error("#{i}")

                    # break if (icnt == 29)                # 後で外す
                end
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "userkey:" + "#{err_id}" + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # ---------------------------------------------------------
        # クラウド連携_ユーザー読み込み
        # ---------------------------------------------------------
        def table_select
            CloudRenUser.all.order(:id)
        end

        # 
        def table_select_join

            # 元のSQL
            # SQL = "Select W.*, "
            # SQL = SQL & "T.ユーザーキー                 As ユーザーキーT "
            # SQL = SQL & "From W_クラウド連携_ユーザー   As W "
            # SQL = SQL & "Left Join T_請求テーブル_楽楽  As T On "
            # SQL = SQL & "W.userkey = T.ユーザーキー "
            # SQL = SQL & "Order By W.id"

            sql = "LEFT OUTER JOIN raku_ren_seikyus ON cloud_ren_users.userkey = raku_ren_seikyus.userkey"
            cloudrenusers = CloudRenUser.joins(sql).select("raku_ren_seikyus.userkey as userkey")

            # bbb = CloudRenUser.joins(sql).to_sql

            return cloudrenusers
        end

        # 
        def table_count
            CloudRenUser.count
        end

        def export_user
        end
    
        def exprt_sise
        end
    end
end
