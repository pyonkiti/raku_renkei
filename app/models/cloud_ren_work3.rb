class CloudRenWork3 < ApplicationRecord
    class << self

        # 
        def table_delete
            connection.execute "TRUNCATE TABLE cloud_ren_work3s;"
        end
        

        # 
        def table_insert(cloudrenchecks, syori:)
            begin
                
                unless cloudrenchecks.empty?

                    err_id = ""
                    # 重複キーの場合、単一キーとIDがかぶらないようにするための処置
                    start_cnt = syori == "key_tanitsu" ? 0 : 1000000

                    cloudrenchecks.each_with_index do |res, icnt|
                    
                        err_id = "#{start_cnt + icnt + 1} - #{res.userkey} - #{res.f_scode}"
                        # ユーザーキーがユニークの場合は、請求キーリンクをセットするが、複数存在する場合は空白
                        seikyu_keylink = syori == "key_tanitsu" ? res.jido_renban : ""
                        
                        sql  = "Insert Into cloud_ren_work3s ( "
                        sql += "id,"
                        sql += "seikyu_keylink,"
                        sql += "userkey,"
                        sql += "f_scode,"
                        sql += "f_sname,"
                        sql += "dantai_kbn,"
                        sql += "jichitai_cd,"
                        sql += "dantai1,"
                        sql += "dantai2,"
                        sql += "bunrui,"
                        sql += "deta_kbn1,"
                        sql += "deta_kbn2"
                        sql += " ) "
                        sql += "Values ( "
                        sql += "#{start_cnt + icnt + 1},"
                        sql += "#{Common.change_kara(seikyu_keylink)},"
                        sql += "#{Common.change_kara(res.userkey)},"
                        sql += "#{Common.change_kara(res.f_scode)},"
                        sql += "#{Common.change_kara(res.f_sname)},"
                        sql += "#{res.dantai_kbn},"
                        sql += "#{res.jichitai_cd},"
                        sql += "#{Common.change_kara(res.dantai1)},"
                        sql += "#{Common.change_kara(res.dantai2)},"
                        sql += "#{Common.change_kara(res.bunrui)},"
                        sql += "#{Common.change_kara(res.deta_kbn1)},"
                        sql += "#{res.deta_kbn2}"
                        sql += " ) "

                        # @@debug.pri_logger.error(sql)
                        ret = ActiveRecord::Base.connection.execute(sql)
                    end
                end
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id-userkey-f_scode:" + "#{err_id}" + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # Q_クラウド連携_連携施設02_楽楽1  / Q_クラウド連携_連携施設02_楽楽2
        def table_select_forexcel(syori:)
            
            wsql = case syori
                when "key_tanitsu" then "deta_kbn2 = 1"
                when "key_jyufuku" then "deta_kbn2 = 2"
                else "id > 0"
            end
            CloudRenWork3.select("*").where(wsql).order("userkey, f_scode")
        end

        # 
        def table_count(syori:)
            
            wsql = case syori
                when "key_tanitsu" then "deta_kbn2 = 1"
                when "key_jyufuku" then "deta_kbn2 = 2"
                else "id > 0"
            end
            CloudRenWork3.where(wsql).count
        end

    end
end
