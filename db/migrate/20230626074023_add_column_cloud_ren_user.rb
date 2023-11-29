class AddColumnCloudRenUser < ActiveRecord::Migration[5.2]
  def change
    add_column :cloud_ren_users, :userkey,          :string     # ユーザーキー
    add_column :cloud_ren_users, :pseudokey,        :string     # ？
    add_column :cloud_ren_users, :remark,           :string     # ユーザー名
    add_column :cloud_ren_users, :db_ip,            :string     # IPアドレス
    add_column :cloud_ren_users, :port,             :string     # ポート番号
    add_column :cloud_ren_users, :almrcv_port,      :string     # アラームポート番号
    add_column :cloud_ren_users, :command_port,     :string     # コマンドポート番号
    add_column :cloud_ren_users, :created_at,       :datetime   # 作成日
    add_index  :cloud_ren_users, :userkey
  end
end
