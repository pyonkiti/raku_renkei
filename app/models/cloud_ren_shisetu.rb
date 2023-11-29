class CloudRenShisetu < ApplicationRecord
    class << self

        # ---------------------------------------------------------
        # テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE cloud_ren_shisetus CASCADE;"
        end

        # ---------------------------------------------------------
        # Sofinet CloudのWebAPI取得（施設データ取得）
        # ---------------------------------------------------------
        def table_insert(table)
            begin
                icnt = 1
                err_id= ""

                table.each do |tbl|
                    url = "https://www.sofinetcloud.net/api/system/get_all_plants?userkey="
                    respon = Net::HTTP.get_response(URI.parse("#{url}#{tbl.userkey.to_s}"))
                    result = JSON.parse(respon.body)
                    
                    result.each do |res|

                        err_id = "#{tbl.userkey} - #{res["F_SCODE"]}"
                        sql  = ""
                        sql += "Insert Into cloud_ren_shisetus( "
                        sql += "id,"
                        sql += "userkey,"
                        sql += "f_scode,"
                        sql += "f_ttype,"
                        sql += "f_sname,"
                        sql += "f_connect,"
                        sql += "f_ip,"
                        sql += "created_at"
                        sql += " ) "
                        sql += "Values ( "
                        sql += "#{icnt},"                                       # id
                        sql += "#{Common.change_kara(tbl.userkey)},"
                        sql += "#{Common.change_kara(res["F_SCODE"])},"
                        sql += "#{Common.change_kara(res["F_TTYPE"])},"
                        sql += "#{Common.change_kara(res["F_SNAME"])},"
                        sql += "#{Common.change_kara(res["F_CONNECT"])},"
                        sql += "#{Common.change_kara(res["F_IP"])},"
                        sql += "#{Common.change_kara(Time.current)}"
                        sql += " )"
                        ret = ActiveRecord::Base.connection.execute(sql)
                        icnt+=1
                    end
                end
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "userkey-f_scode:" + "#{err_id}" + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        def table_count
            CloudRenShisetu.count
        end
    end
end
