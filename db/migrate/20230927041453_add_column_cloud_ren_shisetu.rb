class AddColumnCloudRenShisetu < ActiveRecord::Migration[5.2]
    def change
        add_column :cloud_ren_shisetus, :userkey,          :string     # ユーザーキー
        add_column :cloud_ren_shisetus, :f_scode,          :integer    # 施設コード
        add_column :cloud_ren_shisetus, :f_ttype,          :string     # Tタイプ
        add_column :cloud_ren_shisetus, :f_sname,          :string     # 施設名
        add_column :cloud_ren_shisetus, :f_connect,        :string     # 接続
        add_column :cloud_ren_shisetus, :f_ip,             :string     # IPアドレス
        add_column :cloud_ren_shisetus, :created_at,       :datetime   # 作成日
        add_index  :cloud_ren_shisetus, [:f_scode, :userkey]
    end
end
