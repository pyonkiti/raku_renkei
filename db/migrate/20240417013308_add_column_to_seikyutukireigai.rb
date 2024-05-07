class AddColumnToSeikyutukireigai < ActiveRecord::Migration[5.2]
    def change
      add_column :seikyu_tuki_reigais,  :seikyu_key_link,   :string     # 請求キーリンク
      add_column :seikyu_tuki_reigais,  :sisetu_nm,         :string     # 施設名
      add_column :seikyu_tuki_reigais,  :seikyu_m_su,       :integer    # 請求月数
      add_column :seikyu_tuki_reigais,  :biko_user,         :string     # 備考（ユーザー名）
      add_column :seikyu_tuki_reigais,  :biko_siyou,        :string     # 備考（説明文）
      add_column :seikyu_tuki_reigais,  :created_at,        :datetime   # 作成日
      add_column :seikyu_tuki_reigais,  :updated_at,        :datetime   # 更新日
    end
end
