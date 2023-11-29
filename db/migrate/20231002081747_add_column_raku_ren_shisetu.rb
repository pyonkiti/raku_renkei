class AddColumnRakuRenShisetu < ActiveRecord::Migration[5.2]
    def change
        add_column :raku_ren_shisetus, :seikyu_keylink, :string    # 請求キーリンク
        add_column :raku_ren_shisetus, :bango,          :string    # 番号
        add_column :raku_ren_shisetus, :shisetu,        :string    # 施設名
        add_column :raku_ren_shisetus, :shisetu_cd,     :integer   # 施設コード
        add_column :raku_ren_shisetus, :userkey,        :string    # ユーザーキー
        add_index :raku_ren_shisetus,  [:shisetu_cd, :userkey]
    end
end
