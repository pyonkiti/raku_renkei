# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# Userにデータを登録
def user_create

    ary_tst = [{name: "テスト", name_id: "test", password: "test", password_digest: "test", admin: true}]

    ary_hon = [{name: "管理者", name_id: "admin", password: "admin", password_confirmation: "admin", admin: true},
               {name: "南部",   name_id: "nanbu", password: "nanbu", password_confirmation: "nanbu", admin: true},
               {name: "浅井",   name_id: "asai",  password: "asai",  password_confirmation: "asai",  admin: true}]

    ary_hon.each { |ary| Master::User.create([ ary ]) }
end

# Userデータを表示
def user_disp
    users = Master::User.all
    users.each do |users|
        puts users.name
    end
end

# Userデータを削除
def user_delete
    1.upto(10) do |idx|
        user = Master::User.find_by(id: idx)
        unless user.nil?
            user.destroy
        end
    end
end

# user_delete()
user_create()
# user_disp()

