class AddColumnUser < ActiveRecord::Migration[5.2]

    def change
        # カラムを追加
        add_column :users, :name,               :string     # ユーザー名
        add_column :users, :name_id,            :string     # ユーザーID
        add_column :users, :password_digest,    :string     # パスワード
        add_column :users, :admin,              :boolean    # 管理者フラグ
        add_column :users, :created_at,         :datetime   # 作成日
        add_column :users, :updated_at,         :datetime   # 更新日
    end
end
