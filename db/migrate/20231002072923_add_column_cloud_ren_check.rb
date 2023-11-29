class AddColumnCloudRenCheck < ActiveRecord::Migration[5.2]
    def change
        add_column :cloud_ren_checks, :dantai_kbn,   :integer   # 団体区分
        add_column :cloud_ren_checks, :jichitai_cd,  :integer   # 自治体コード
        add_column :cloud_ren_checks, :dantai1,      :string    # 団体名１
        add_column :cloud_ren_checks, :dantai2,      :string    # 団体名２
        add_column :cloud_ren_checks, :bunrui_cd,    :integer   # 分類
        add_column :cloud_ren_checks, :bunrui,       :string    # 分類名
        add_column :cloud_ren_checks, :userkey,      :string    # ユーザーキー
        add_column :cloud_ren_checks, :deta_kbn1,    :string    # データ区分１
        add_column :cloud_ren_checks, :deta_kbn2,    :integer   # データ区分２
        add_column :cloud_ren_checks, :deta_kbn3,    :integer   # データ区分３
        add_column :cloud_ren_checks, :msg,          :string    # メッセージ
        add_column :cloud_ren_checks, :created_at,   :datetime  # 作成日
        add_index  :cloud_ren_checks, :userkey
    end
end
