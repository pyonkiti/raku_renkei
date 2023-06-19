class ChangeColumnToseikyuTukiCal < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    # Not Null制約を追加
    def set_null(flg)

        # カラム
        change_column_null :seikyu_tuki_cals, :seikyu_key_link,     flg     # 請求キーリンク
        change_column_null :seikyu_tuki_cals, :yuusyou_kaishi_ym,   flg     # 有償開始年月
        change_column_null :seikyu_tuki_cals, :yuusyou_syuryo_ym,   flg     # 有償終了年月
        change_column_null :seikyu_tuki_cals, :seikyu_m_su,         flg     # 請求月数
        change_column_null :seikyu_tuki_cals, :siharai_kikan_cd,    flg     # 支払期間コード
        change_column_null :seikyu_tuki_cals, :print_flg,           flg     # 印刷フラグ
        change_column_null :seikyu_tuki_cals, :seikyu_ym,           flg    # 請求年月
    end

    # デフォルト値を追加
    def set_default(flg)

        # カラム
        change_column_default :seikyu_tuki_cals, :seikyu_key_link,     flg      # 請求キーリンク
        change_column_default :seikyu_tuki_cals, :yuusyou_kaishi_ym,   flg      # 有償開始年月
        change_column_default :seikyu_tuki_cals, :yuusyou_syuryo_ym,   flg      # 有償終了年月
        change_column_default :seikyu_tuki_cals, :seikyu_m_su,         0        # 請求月数
        change_column_default :seikyu_tuki_cals, :siharai_kikan_cd,    flg      # 支払期間コード
        change_column_default :seikyu_tuki_cals, :print_flg,           flg      # 印刷フラグ
        change_column_default :seikyu_tuki_cals, :seikyu_ym,           flg      # 請求年月
    end
end
