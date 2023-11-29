class AddColumnCloudRenWork3 < ActiveRecord::Migration[5.2]
    def change
        add_column :cloud_ren_work3s, :seikyu_keylink,   :string    # 請求キーリンク
        add_column :cloud_ren_work3s, :userkey,          :string    # ユーザーキー
        add_column :cloud_ren_work3s, :f_scode,          :string    # 施設コード
        add_column :cloud_ren_work3s, :f_sname,          :string    # 施設名
        add_column :cloud_ren_work3s, :dantai_kbn,       :integer   # 団体区分
        add_column :cloud_ren_work3s, :jichitai_cd,      :integer   # 自治体コード
        add_column :cloud_ren_work3s, :dantai1,          :string    # 団体名１
        add_column :cloud_ren_work3s, :dantai2,          :string    # 団体名２
        add_column :cloud_ren_work3s, :bunrui,           :string    # 分類名
        add_column :cloud_ren_work3s, :deta_kbn1,        :string    # データ区分１
        add_column :cloud_ren_work3s, :deta_kbn2,        :integer   # データ区分２
        add_index  :cloud_ren_work3s, [:seikyu_keylink, :userkey]
    end
end
