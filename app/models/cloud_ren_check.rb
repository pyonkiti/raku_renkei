class CloudRenCheck < ApplicationRecord
    class << self

        # テーブルを全件削除
        def table_delete
            connection.execute "TRUNCATE TABLE cloud_ren_checks CASCADE;"
        end

        # 新規ユーザーだけを更新（SofinetCloud側：有、楽楽側：無）
        # SofinetCloud側にあり、楽楽側にない、新規ユーザーだけを更新
        def table_insert(cloudrenusers)

            begin
                err_id = ""
                cloudrenusers.each_with_index do |res, icnt|
                    
                    err_id = "#{icnt + 1} - #{res.userkey}"
                    sql ="Insert Into cloud_ren_checks ( "
                    sql += "id,"
                    sql += "dantai_kbn,"
                    sql += "jichitai_cd,"
                    sql += "dantai1,"
                    sql += "dantai2,"
                    sql += "bunrui_cd,"
                    sql += "bunrui,"
                    sql += "userkey,"
                    sql += "deta_kbn1,"
                    sql += "deta_kbn2,"
                    sql += "deta_kbn3,"
                    sql += "msg,"
                    sql += "created_at"
                    sql += " ) "
                    sql += "Values ( "
                    sql += "#{icnt + 1},"
                    sql += "0,"
                    sql += "0,"
                    sql += "#{Common.change_kara("")},"
                    sql += "#{Common.change_kara("")},"
                    sql += "0,"
                    sql += "#{Common.change_kara("")},"
                    sql += "#{Common.change_kara(res.userkey)},"
                    sql += "#{Common.change_kara("新規")},"
                    sql += "0,"
                    sql += "0,"
                    sql += "#{Common.change_kara("SofinetCloud側に存在するが、楽楽の請求テーブルに存在しないユーザーです")},"
                    sql += "#{Common.change_kara(Time.current)}"
                    sql += " ) "
                    
                    ret = ActiveRecord::Base.connection.execute(sql)
                end
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id-userkey:" + "#{err_id}" + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # 既存、廃止ユーザーだけを更新（SofinetCloud側：有 楽楽側：有 SofinetCloud側：無、楽楽側：有）
        # 団体区分=1:自治体 団体区分=2:民間
        def table_insert_kizon(rakurenseikyus, id_max, dantai_kbn:)

            begin
                err_id, record_cnt = "", 0

                rakurenseikyus.each_with_index do |res, icnt|
                    
                    record_cnt = id_max + icnt + 1
                    err_id = "#{record_cnt} - #{res.userkey_r}"
                    
                    case dantai_kbn
                        when 1                                      # 自治体
                            jichitai_cd = res.jichitai_cd
                            dantai1, dantai2 = res.todoufuken, res.shikutyouson
                        when 2                                      # 民間
                            jichitai_cd = res.kigyou_cd
                            dantai1, dantai2 = res.kigyou, ""
                    end

                    if res.userkey_c.nil?
                        msg = "楽楽の請求テーブルに存在するが、SofinetCloud側に存在しないユーザーです"
                        data_kbn1 = "廃止"
                    else
                        msg = "楽楽の請求テーブルにも、SofintCloud側にも存在するユーザーです"
                        data_kbn1 = "既存"
                    end

                    sql ="Insert Into cloud_ren_checks ( "
                    sql += "id,"
                    sql += "dantai_kbn,"
                    sql += "jichitai_cd,"
                    sql += "dantai1,"
                    sql += "dantai2,"
                    sql += "bunrui_cd,"
                    sql += "bunrui,"
                    sql += "userkey,"
                    sql += "deta_kbn1,"
                    sql += "deta_kbn2,"
                    sql += "deta_kbn3,"
                    sql += "msg,"
                    sql += "created_at"
                    sql += " ) "
                    sql += "Values ( "
                    sql += "#{record_cnt},"
                    sql += "#{dantai_kbn},"
                    sql += "#{Common.change_kara(jichitai_cd)},"
                    sql += "#{Common.change_kara(dantai1)},"
                    sql += "#{Common.change_kara(dantai2)},"
                    sql += "0,"
                    sql += "#{Common.change_kara(res.bunrui)},"
                    sql += "#{Common.change_kara(res.userkey_r)},"
                    sql += "#{Common.change_kara(data_kbn1)},"
                    sql += "0,"
                    sql += "0,"
                    sql += "#{Common.change_kara(msg)},"
                    sql += "#{Common.change_kara(Time.current)}"
                    sql += " ) "
                    
                    ret = ActiveRecord::Base.connection.execute(sql)
                end
                return true, nil, record_cnt
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id-userkey:" + "#{err_id}" + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。", nil
            end
        end

        # idの最大値を取得
        def table_maximum
            CloudRenCheck.maximum('id')
        end

        # データ区分でユーザーキーがユニークか複数存在するか判別できるようにする
        def table_select_save(rakurenseikyus)

            begin
                err_id = ""
                rakurenseikyus.each do |ret_raku|

                    cloudrencheck = CloudRenCheck.select(:id, :deta_kbn2, :deta_kbn3)
                                                 .where(userkey: ret_raku[0])
                                                 .order(:dantai_kbn, :jichitai_cd, :id)
                    
                    cloudrencheck.each_with_index do |ret_cloud, icnt|

                        err_id = "#{ret_cloud.id}-#{ret_raku[0]}"
                        if ret_raku[1] == 1                         # Group件数（userkeyがユニーク）
                            ret_cloud.deta_kbn2 = 1
                        else
                            ret_cloud.deta_kbn2 = 2                 # ユーザーキーが２件以上存在
                            ret_cloud.deta_kbn3 = 1 if icnt == 0    # ユーザーキーが２件以上存在する場合、任意の１件のみ1を更新、残りは0
                        end
                        ret_cloud.save!(:validate => false)
                    end
                end
                return true, nil
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "id-userkey:" + "#{err_id}" + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # Excel出力用の抽出
        def table_select_forexcel
            cloudrencheck = CloudRenCheck.order(:deta_kbn1, :dantai_kbn, :jichitai_cd, :bunrui_cd, :userkey)
        end

        # 新規施設分のデータ抽出
        def table_select_newshisetu(syori:)
            
            cloudrenchecks = case syori
                
                # Q_クラウド連携_新規施設01_楽楽1 （Accessの元ネタ）
                # Q_クラウド連携_新規施設02_楽楽1 （Accessの元ネタ）
                when "key_tanitsu"                                  # ユーザーキーがユニーク
                    
                    ssql  = "cloud_ren_shisetus.userkey,"
                    ssql << "cloud_ren_shisetus.f_scode,"
                    ssql << "cloud_ren_shisetus.f_sname,"
                    ssql << "raku_ren_seikyus.jido_renban,"         # 請求キーリンクのこと（単一キーの場合は連携して問題なし）
                    ssql << "cloud_ren_checks.dantai_kbn,"
                    ssql << "cloud_ren_checks.jichitai_cd,"
                    ssql << "cloud_ren_checks.dantai1,"
                    ssql << "cloud_ren_checks.dantai2,"
                    ssql << "cloud_ren_checks.bunrui,"
                    ssql << "cloud_ren_checks.deta_kbn1,"
                    ssql << "cloud_ren_checks.deta_kbn2"

                    jsql  = "LEFT OUTER JOIN cloud_ren_shisetus ON  cloud_ren_shisetus.userkey = cloud_ren_checks.userkey "
                    jsql << "LEFT OUTER JOIN raku_ren_seikyus   ON  raku_ren_seikyus.userkey   = cloud_ren_shisetus.userkey "
                    jsql << "LEFT OUTER JOIN raku_ren_shisetus  ON (raku_ren_shisetus.userkey  = cloud_ren_shisetus.userkey AND raku_ren_shisetus.shisetu_cd = cloud_ren_shisetus.f_scode )"

                    CloudRenCheck.joins(jsql).select(ssql)
                            .where("raku_ren_shisetus.shisetu IS NULL")
                            .where("cloud_ren_checks.deta_kbn2 = 1")
                            .where("cloud_ren_checks.deta_kbn1 = \'既存\'")
                            .order("cloud_ren_shisetus.userkey, cloud_ren_shisetus.f_scode")

                # Q_クラウド連携_新規施設01_楽楽2 （Accessの元ネタ）
                # Q_クラウド連携_新規施設02_楽楽2 （Accessの元ネタ）
                when "key_jyufuku"                                  # ユーザーキーが複数存在

                    ssql  = "cloud_ren_shisetus.userkey,"
                    ssql << "cloud_ren_shisetus.f_scode,"
                    ssql << "cloud_ren_shisetus.f_sname,"
                    ssql << "cloud_ren_checks.dantai_kbn,"
                    ssql << "cloud_ren_checks.jichitai_cd,"
                    ssql << "cloud_ren_checks.dantai1,"
                    ssql << "cloud_ren_checks.dantai2,"
                    ssql << "cloud_ren_checks.bunrui,"
                    ssql << "cloud_ren_checks.deta_kbn1,"
                    ssql << "cloud_ren_checks.deta_kbn2"

                    jsql  = "LEFT OUTER JOIN cloud_ren_shisetus ON  cloud_ren_shisetus.userkey = cloud_ren_checks.userkey "
                    jsql << "LEFT OUTER JOIN raku_ren_shisetus  ON (raku_ren_shisetus.userkey  = cloud_ren_shisetus.userkey AND raku_ren_shisetus.shisetu_cd = cloud_ren_shisetus.f_scode )"
                    
                    CloudRenCheck.joins(jsql).select(ssql)
                            .where("raku_ren_shisetus.shisetu IS NULL")
                            .where("cloud_ren_checks.deta_kbn3 = 1")
                            .where("cloud_ren_checks.deta_kbn2 = 2")
                            .where("cloud_ren_checks.deta_kbn1 = \'既存\'")
                            .order("cloud_ren_shisetus.userkey, cloud_ren_shisetus.f_scode")
            end
            return cloudrenchecks
        end
    end
end
