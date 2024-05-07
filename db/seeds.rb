# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Usersテーブルの操作
class Seeds_User
    class << self

        # データを登録
        def tbl_create
            ary_tst = [{name: "テスト", name_id: "test", password: "test", password_digest: "test", admin: true}]
            ary_hon = [{name: "管理者", name_id: "admin", password: "admin", password_confirmation: "admin", admin: true},
                       {name: "南部",   name_id: "nanbu", password: "nanbu", password_confirmation: "nanbu", admin: true},
                       {name: "浅井",   name_id: "asai",  password: "asai",  password_confirmation: "asai",  admin: true}]
            ary_hon.each { |ary| Master::User.create([ ary ]) }
        end

        # データを表示
        def display
            users = Master::User.all
            users.each do |users|
                puts users.name
            end
        end

        # データを削除
        def tbl_delete
            1.upto(30) do |idx|
                user = Master::User.find_by(id: idx)
                unless user.nil?
                    user.destroy
                end
            end
        end
    end
end

# seikyu_tuki_reigaisテーブルの操作
class Seeds_SeikyuTukiReigai
    class << self
        # データを表示
        def display
            res = SeikyuTukiReigai.all.order(:id)
            res.each do |res|
                puts "id:#{res.id} seikyu_key_link:#{res.seikyu_key_link} sisetu_nm:#{res.sisetu_nm}"
            end
        end

        # データを削除
        def tbl_delete
            SeikyuTukiReigai.where(id: [1..30]).delete_all
        end
        
        # データを登録
        def tbl_create

            hash =  []
            # hash << {id: 2,  seikyu_key_link: "000000001", sisetu_nm: "旭ヶ丘マンホールポンプ所", seikyu_m_su: 3, biko_user: "備考１です", biko_siyou: "備考２です"}
            # hash << {id: 3,  seikyu_key_link: "000000001", sisetu_nm: "曙橋マンホールポンプ所", seikyu_m_su: 4, biko_user: "備考１です", biko_siyou: "備考２です"}
            # hash << {id: 4,  seikyu_key_link: "000000001", sisetu_nm: "テスト施設", seikyu_m_su: 12, biko_user: "備考１です", biko_siyou: "備考２です"}
            # hash << {id: 5,  seikyu_key_link: "000000010", sisetu_nm: "テスト施設", seikyu_m_su: 12, biko_user: "備考１です", biko_siyou: "備考２です"}

            hash << {id: 1, seikyu_key_link: "000000251", sisetu_nm: "ウイルスソフト（年間）", seikyu_m_su: 1, biko_user: "株式会社フソウメンテック（岡山市簡水）", biko_siyou: "支払期間は年度末（３月）ですが、この施設だけ強制的に１ヶ月請求で計算します"}
            hash << {id: 2, seikyu_key_link: "000000251", sisetu_nm: "自動化ツール更新費（年間）", seikyu_m_su: 1, biko_user: "株式会社フソウメンテック（岡山市簡水）", biko_siyou: "支払期間は年度末（３月）ですが、この施設だけ強制的に１ヶ月請求で計算します"}
            
            hash.each { |ary|
                SeikyuTukiReigai.create(ary)
            }
        end
    end
end

# Usersテーブルの操作
Seeds_User.instance_exec {
    # display
    # tbl_create
}

# seikyu_tuki_reigaisテーブルの操作
Seeds_SeikyuTukiReigai.instance_exec {
    # display
    # tbl_delete
    # display
    # tbl_create
    # display
}

