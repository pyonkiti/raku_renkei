class AddColumnToseikyuTukiCal < ActiveRecord::Migration[5.2]

    def change
        # カラムを追加
        add_column      :seikyu_tuki_cals, :seikyu_key_link,     :string                                # 請求キーリンク
        add_column      :seikyu_tuki_cals, :yuusyou_kaishi_ym,   :string                                # 有償開始年月
        add_column      :seikyu_tuki_cals, :yuusyou_syuryo_ym,   :string                                # 有償終了年月
        add_column      :seikyu_tuki_cals, :seikyu_m_su,         :integer                               # 請求月数
        add_column      :seikyu_tuki_cals, :siharai_kikan_cd,    :string                                # 支払期間コード
        add_column      :seikyu_tuki_cals, :print_flg,           :string                                # 印刷フラグ
        add_column      :seikyu_tuki_cals, :seikyu_ym,           :string                                # 請求年月 Add 2023/06/05
        add_reference   :seikyu_tuki_cals, :sisetu_kanribu_teisyutu0, null: false, foreign_key: true    # 外部キー Add 2023/06/05
    end
end
