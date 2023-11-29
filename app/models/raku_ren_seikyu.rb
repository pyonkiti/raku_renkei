class RakuRenSeikyu < ApplicationRecord
    class << self

        # ---------------------------------------------------------
        # テーブルを全件削除
        # ---------------------------------------------------------
        def table_delete
            connection.execute "TRUNCATE TABLE raku_ren_seikyus;"
        end

        # ---------------------------------------------------------
        # CSVファイルをインポート
        # ---------------------------------------------------------
        def table_import(file)
            begin
                err_id = "", icnt = 1
                CSV.foreach(file.path, headers: true) do |row|
                    hash = {}
                    hash["id"]                  = icnt
                    hash["jido_renban"], err_id = row[0], row[0]
                    hash["dantai_kbn"]          = Common.check_integer(row[1])
                    hash["jichitai_cd"]         = Common.check_integer(row[2])
                    hash["todoufuken"]          = row[3]
                    hash["shikutyouson"]        = row[4]
                    hash["kigyou_cd"]           = Common.check_integer(row[5])
                    hash["kigyou"]              = row[6]
                    hash["bunrui"]              = row[7]
                    hash["userkey"]             = row[8]
                    icnt+=1

                    raku_ren_seikyu = new
                    raku_ren_seikyu.attributes = hash
                    raku_ren_seikyu.save!
                end
                return true, "Access連携出力（請求）の取り込みが完了しました。　処理件数は #{table_count(1)} 件です。"
            rescue => ex
                err = self.name.to_s + "." + __method__.to_s + " : " + ex.message
                err = err + " : " + "自動採番:" + err_id.to_s + "の更新でエラーが発生しています"
                @@debug.pri_logger.error(err)
                return false, "エラーが発生しました。"
            end
        end

        # ---------------------------------------------------------
        # データ件数
        # ---------------------------------------------------------
        def table_count(flg)
            case flg
                when 0 then RakuRenSeikyu.to_s
                when 1 then RakuRenSeikyu.count.to_s(:delimited)
            end
        end

        def table_select_join(dantai_kbn)

            case dantai_kbn
                when 1
                    # Accessのサンプル
                    # '--------------------------------------------------------
                    # '請求テーブルの読み込み（団体区分=1:自治体）
                    # '--------------------------------------------------------
                    # SQL = "Select T_請求テーブル_楽楽.団体区分     As 請求_団体区分, "
                    # SQL = SQL & " T_請求テーブル_楽楽.自治体コード As 請求_自治体コード, "
                    # SQL = SQL & " T_請求テーブル_楽楽.ユーザーキー As 請求_ユーザーキー, "
                    # SQL = SQL & " T_請求テーブル_楽楽.分類名       As 請求_分類, "
                    # SQL = SQL & " T_請求テーブル_楽楽.都道府県名   As 自治体_都道府県名, "
                    # SQL = SQL & " T_請求テーブル_楽楽.市区町村名   As 自治体_市区町村名, "
                    # SQL = SQL & " T_請求テーブル_楽楽.分類名       As 分類_名称, "
                    # SQL = SQL & " W_クラウド連携_ユーザー.userkey  As W_userkey "
                    # SQL = SQL & " "
                    # SQL = SQL & " From T_請求テーブル_楽楽 "
                    # SQL = SQL & " Left Join W_クラウド連携_ユーザー On  T_請求テーブル_楽楽.ユーザーキー = W_クラウド連携_ユーザー.userkey "
                    # SQL = SQL & " "
                    # SQL = SQL & " Where T_請求テーブル_楽楽.団体区分     = 1"
                    # SQL = SQL & " Order By T_請求テーブル_楽楽.自動採番"
                    
                    sql_select = []
                    sql_select << "raku_ren_seikyus.jichitai_cd"            # T_請求テーブル_楽楽.自治体コード
                    sql_select << "raku_ren_seikyus.userkey as userkey_r"   # T_請求テーブル_楽楽.ユーザーキー
                    sql_select << "raku_ren_seikyus.todoufuken"             # T_請求テーブル_楽楽.都道府県名
                    sql_select << "raku_ren_seikyus.shikutyouson"           # T_請求テーブル_楽楽.市区町村名
                    sql_select << "raku_ren_seikyus.bunrui"                 # T_請求テーブル_楽楽.分類名
                    sql_select << "cloud_ren_users.userkey as userkey_c"    # W_クラウド連携_ユーザー.ユーザーキー
                    
                    # ユーザーキーは２つも不要
                when 2
                    # Accessのサンプル
                    # '--------------------------------------------------------
                    # '請求テーブルの読み込み（団体区分=2:民間）
                    # '--------------------------------------------------------
                    # SQL = "Select T_請求テーブル_楽楽.団体区分     As 請求_団体区分, "
                    # SQL = SQL & " T_請求テーブル_楽楽.企業コード   As 請求_自治体コード, "
                    # SQL = SQL & " T_請求テーブル_楽楽.ユーザーキー As 請求_ユーザーキー, "
                    # SQL = SQL & " T_請求テーブル_楽楽.分類名       As 請求_分類, "
                    # SQL = SQL & " T_請求テーブル_楽楽.企業名       As 企業_企業名, "
                    # SQL = SQL & " T_請求テーブル_楽楽.分類名       As 分類_名称, "
                    # SQL = SQL & " W_クラウド連携_ユーザー.userkey  As W_userkey "
                    # SQL = SQL & " "
                    # SQL = SQL & " From T_請求テーブル_楽楽 "
                    # SQL = SQL & " Left Join W_クラウド連携_ユーザー On  T_請求テーブル_楽楽.ユーザーキー = W_クラウド連携_ユーザー.userkey "
                    # SQL = SQL & " "
                    # SQL = SQL & " Where T_請求テーブル_楽楽.団体区分     = 2"
                    # SQL = SQL & " Order By T_請求テーブル_楽楽.自動採番"
                    
                    
                    sql_select = []
                    sql_select << "raku_ren_seikyus.kigyou_cd"      # T_請求テーブル_楽楽.企業コード
                    sql_select << "raku_ren_seikyus.userkey as userkey_r"      # T_請求テーブル_楽楽.ユーザーキー
                    sql_select << "raku_ren_seikyus.kigyou"         # T_請求テーブル_楽楽.企業名
                    sql_select << "raku_ren_seikyus.bunrui"         # T_請求テーブル_楽楽.分類名
                    sql_select << "cloud_ren_users.userkey as userkey_c"       # W_クラウド連携_ユーザー.ユーザーキー

                    # ちょっとずつ動作テストをしながらの方がいい
                    # jsで画面のwaiteができていない
            end
                
            sql_join = "LEFT OUTER JOIN cloud_ren_users on raku_ren_seikyus.userkey = cloud_ren_users.userkey"
            sql_where = "raku_ren_seikyus.dantai_kbn = #{dantai_kbn}"
            sql_order = "raku_ren_seikyus.jido_renban"

            rakurenseikyus = RakuRenSeikyu.joins(sql_join)
                                    .select(sql_select.join(","))
                                    .where(sql_where)
                                    .order(sql_order)
            
            # @@debug.pri_logger.error(RakuRenSeikyu.joins(sql_join).select(sql_select).where(sql_where).order(sql_order).to_sql)
            # @@debug.pri_logger.error(RakuRenSeikyu.joins(sql_join).select(sql_select).where(sql_where).order(sql_order))
            
            
            
            
            return rakurenseikyus
        end
        
        def table_select_group
            
            # Accessの元SQL
            # SQL = "Select T_請求テーブル_楽楽.ユーザーキー        As ユーザーキー, "
            # SQL = SQL & " Count(T_請求テーブル_楽楽.ユーザーキー) As ユーザーキー_Count "
            # SQL = SQL & " From T_請求テーブル_楽楽"
            # SQL = SQL & " Group By T_請求テーブル_楽楽.ユーザーキー"
            # SQL = SQL & " Order By Count(T_請求テーブル_楽楽.ユーザーキー) DESC;"
            
            rakurenseikyus = RakuRenSeikyu.group("userkey").count

            # @@debug.pri_logger.error(rakurenseikyus)

            # rakurenseikyus.each do |res|
            #     # @@debug.pri_logger.error(res.userkey_cnt)
            #     @@debug.pri_logger.error(res)
            #     @@debug.pri_logger.error("#{res[0]} - #{res[1]}")
            # end
            
            return rakurenseikyus
        end
    end
end
