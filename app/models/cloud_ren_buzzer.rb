class CloudRenBuzzer < ApplicationRecord
    class << self
       
        # テーブルから取得したデータの読み込み
        def table_each(table, sql_flg, syori_flg)
            begin
                ret, msg, err_id = true, nil, []
                sdate  = Time.current.to_s
                
                table.each do |tbl|
                    
                    err_id, tblcol_h = [], {}
                    
                    case syori_flg
                        # SofinetCloudから取得したデータ
                        when "cloud"
                        
                            err_id   = "#{tbl["userkey"]} #{tbl["buzzer_id"]}".split(" ")

                            tblcol_h = { userkey:     tbl["userkey"],
                                            buzzer_id:   tbl["buzzer_id"],
                                            buzzer_name: tbl["buzzer_name"],
                                            upd_flg:     "",
                                            sts_flg:     0,
                                            sdate:       sdate
                                        }
                        
                        # テーブルから取得したデータ
                        when "local"

                            err_id, upd_flg = case sql_flg
                                when "oy-ko"   then ["#{tbl["userkey_oy"]} #{tbl["buzzer_id_oy"]}".split(" "), "既存"]
                                when "oy-only" then ["#{tbl["userkey_oy"]} #{tbl["buzzer_id_oy"]}".split(" "), "新規"]
                                when "ko-only" then ["#{tbl["userkey_ko"]} #{tbl["buzzer_id_ko"]}".split(" "), "廃止"]
                                else ""
                            end
                            
                            tblcol_h = { userkey:     tbl["userkey_ko"].nil?     ? tbl["userkey_oy"]     : tbl["userkey_ko"],
                                         buzzer_id:   tbl["buzzer_id_ko"].nil?   ? tbl["buzzer_id_oy"]   : tbl["buzzer_id_ko"],
                                         buzzer_name: tbl["buzzer_name_ko"].nil? ? tbl["buzzer_name_oy"] : tbl["buzzer_name_ko"],
                                         upd_flg:     upd_flg,
                                         sts_flg:     2,
                                         sdate:       sdate
                                        }
                        else nil
                    end

                    # テーブルの新規更新
                    ret, msg = table_insert(tblcol_h)
                    break if !ret
                end
                
                return true,  nil if  ret
                return false, msg if !ret

            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "userkey:" + "#{err_id[0]}" + " " + "buzzer_id:" + "#{err_id[1]} "
                err = err + case syori_flg
                    when "cloud" then "SofinetCloudからのブザーデータ"
                    when "local" then "cloud_ren_buzzers"
                end
                err = err + "の読み込み処理でエラーが発生しています。"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # sts_flg:0 Sofinet Cloudから取得したデータ、sts_flg:1 既存のデータを削除
        # テーブルからデータを削除
        def table_delete
            begin
                CloudRenBuzzer.where(sts_flg: [0, 1]).destroy_all
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " cloud_ren_buzzersの削除でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # データ件数を取得
        def table_count
            CloudRenBuzzer.where(sts_flg: 1).count
        end
        
        # テーブルにデータを新規更新
        def table_insert(tblcol_h)
            
            err_id = []
            err_id << "#{tblcol_h[:userkey]}"
            err_id << "#{tblcol_h[:buzzer_id]}"

            begin
                sql  = ""
                sql += "Insert Into cloud_ren_buzzers( "
                sql += "userkey,"                                               # ユーザーキー
                sql += "buzzer_id,"                                             # ブザーID
                sql += "buzzer_name,"                                           # ブザー名
                sql += "upd_flg,"                                               # 更新フラグ
                sql += "sts_flg,"                                               # 状態フラグ
                sql += "created_at,"                                            # 作成日
                sql += "updated_at"                                             # 更新日
                sql += ")"
                sql += "Values ( "
                sql += "#{Common.change_kara(tblcol_h[:userkey])},"
                sql += "#{Common.change_kara(tblcol_h[:buzzer_id])},"
                sql += "#{Common.change_kara(tblcol_h[:buzzer_name])},"
                sql += "#{Common.change_kara(tblcol_h[:upd_flg])},"
                sql += "#{tblcol_h[:sts_flg].to_i},"
                sql += "#{Common.change_kara(tblcol_h[:sdate].to_datetime)},"
                sql += "#{Common.change_kara(tblcol_h[:sdate].to_datetime)}"
                sql += " )"
                ret = ActiveRecord::Base.connection.execute(sql)

                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "userkey:" + "#{err_id[0]}" + " " + "buzzer_id:" + "#{err_id[1]} "
                err = err + "cloud_ren_buzzersのInsertでエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # テーブルの読み込み
        def table_select_join(sql_flg)
            
            begin
                sql_select, sql_join = [], []

                cloudRenBuzzers = case sql_flg
                    # 親子（親：データ有、子：データ有）
                    when "oy-ko"
                        
                        sql_select << "cloud_ren_buzzers.userkey        AS userkey_oy"          # ユーザーキー（親）
                        sql_select << "cloud_ren_buzzers.buzzer_id      AS buzzer_id_oy"        # ブザーID（親）
                        sql_select << "cloud_ren_buzzers.buzzer_name    AS buzzer_name_oy"      # ブザー名（親）
                        sql_select << "cloud_ren_buzzers_ko.userkey     AS userkey_ko"          # ユーザーキー（子）
                        sql_select << "cloud_ren_buzzers_ko.buzzer_id   AS buzzer_id_ko"        # ブザーID（子）
                        sql_select << "cloud_ren_buzzers_ko.buzzer_name AS buzzer_name_ko"      # ブザー名（子）
                        
                        sql_join << "INNER JOIN cloud_ren_buzzers AS cloud_ren_buzzers_ko "
                        sql_join << "ON  cloud_ren_buzzers_ko.userkey   = cloud_ren_buzzers.userkey "
                        sql_join << "AND cloud_ren_buzzers_ko.buzzer_id = cloud_ren_buzzers.buzzer_id "
                        sql_join << "AND cloud_ren_buzzers_ko.sts_flg   = 1"

                        CloudRenBuzzer.joins(sql_join)
                                        .select(sql_select.join(","))
                                        .where("cloud_ren_buzzers.sts_flg = 0")
                                        .order("cloud_ren_buzzers.userkey, cloud_ren_buzzers.buzzer_id")
                    
                    # 親のみ（親：データ有、子：データ無）
                    when "oy-only"

                        sql_select << "cloud_ren_buzzers.userkey        AS userkey_oy"          # ユーザーキー（親）
                        sql_select << "cloud_ren_buzzers.buzzer_id      AS buzzer_id_oy"        # ブザーID（親）
                        sql_select << "cloud_ren_buzzers.buzzer_name    AS buzzer_name_oy"      # ブザー名（親）
                        sql_select << "cloud_ren_buzzers_ko.userkey     AS userkey_ko"          # ユーザーキー（子）
                        sql_select << "cloud_ren_buzzers_ko.buzzer_id   AS buzzer_id_ko"        # ブザーID（子）
                        sql_select << "cloud_ren_buzzers_ko.buzzer_name AS buzzer_name_ko"      # ブザー名（子）
                        
                        sql_join << "LEFT JOIN cloud_ren_buzzers AS cloud_ren_buzzers_ko "
                        sql_join << "ON  cloud_ren_buzzers_ko.userkey   = cloud_ren_buzzers.userkey "
                        sql_join << "AND cloud_ren_buzzers_ko.buzzer_id = cloud_ren_buzzers.buzzer_id "
                        sql_join << "AND cloud_ren_buzzers_ko.sts_flg   = 1"

                        CloudRenBuzzer.joins(sql_join)
                                        .select(sql_select.join(","))
                                        .where("cloud_ren_buzzers.sts_flg = 0")
                                        .where("cloud_ren_buzzers_ko.sts_flg IS NULL")
                                        .order("cloud_ren_buzzers.userkey, cloud_ren_buzzers.buzzer_id")
                    
                    # 子のみ （親：データ無、子：データ有）
                    when "ko-only"

                        sql_select << "cloud_ren_buzzers.userkey        AS userkey_ko"          # ユーザーキー（子）
                        sql_select << "cloud_ren_buzzers.buzzer_id      AS buzzer_id_ko"        # ブザーID（子）
                        sql_select << "cloud_ren_buzzers.buzzer_name    AS buzzer_name_ko"      # ブザー名（子）
                        sql_select << "cloud_ren_buzzers_oy.userkey     AS userkey_oy"          # ユーザーキー（親）
                        sql_select << "cloud_ren_buzzers_oy.buzzer_id   AS buzzer_id_oy"        # ブザーID（親）
                        sql_select << "cloud_ren_buzzers_oy.buzzer_name AS buzzer_name_oy"      # ブザー名（親）
                        
                        sql_join << "LEFT JOIN cloud_ren_buzzers AS cloud_ren_buzzers_oy "
                        sql_join << "ON  cloud_ren_buzzers_oy.userkey   = cloud_ren_buzzers.userkey "
                        sql_join << "AND cloud_ren_buzzers_oy.buzzer_id = cloud_ren_buzzers.buzzer_id "
                        sql_join << "AND cloud_ren_buzzers_oy.sts_flg   = 0"

                        CloudRenBuzzer.joins(sql_join)
                                        .select(sql_select.join(","))
                                        .where("cloud_ren_buzzers.sts_flg = 1")
                                        .where("cloud_ren_buzzers_oy.sts_flg IS NULL")
                                        .order("cloud_ren_buzzers.userkey, cloud_ren_buzzers.buzzer_id")
                    else nil
                end
                return true, nil, cloudRenBuzzers
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " データ抽出でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。", nil
            end
        end

        # 状態フラグを2→1に更新
        def table_update
            begin
                CloudRenBuzzer.update_all(sts_flg: 1)
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " 「sts_flg」の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # CSVに出力
        def table_select_forexcel
            where_hash = { "nihonsoft" => "日本ソフト開発" }
            CloudRenBuzzer.where.not(userkey: where_hash.keys ).order(:userkey, :buzzer_id)
        end
    end
end
