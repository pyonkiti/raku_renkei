class AddColumnToCloudRenBuzzer < ActiveRecord::Migration[5.2]
  def change
    add_column :cloud_ren_buzzers,  :userkey,     :string     # ユーザーキー
    add_column :cloud_ren_buzzers,  :buzzer_id,   :string     # ブザーID
    add_column :cloud_ren_buzzers,  :buzzer_name, :string     # ブザー名
    add_column :cloud_ren_buzzers,  :upd_flg,     :string     # 更新フラグ
    add_column :cloud_ren_buzzers,  :sts_flg,     :integer    # 状態フラグ
    add_column :cloud_ren_buzzers,  :created_at,  :datetime   # 作成日
    add_column :cloud_ren_buzzers,  :updated_at,  :datetime   # 更新日
  end
end
