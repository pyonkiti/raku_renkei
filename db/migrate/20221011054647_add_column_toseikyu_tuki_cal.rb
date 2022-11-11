class AddColumnToseikyuTukiCal < ActiveRecord::Migration[5.2]

    def change
        # カラムを追加
        add_column :seikyu_tuki_cals, :seikyu_key_link,     :string     # 請求キーリンク
        add_column :seikyu_tuki_cals, :yuusyou_kaishi_ym,   :string     # 有償開始年月
        add_column :seikyu_tuki_cals, :yuusyou_syuryo_ym,   :string     # 有償終了年月
        add_column :seikyu_tuki_cals, :seikyu_m_su,         :integer    # 請求月数
        add_column :seikyu_tuki_cals, :siharai_kikan_cd,    :string     # 支払期間コード
        add_column :seikyu_tuki_cals, :print_flg,           :string     # 印刷フラグ
    end
end
