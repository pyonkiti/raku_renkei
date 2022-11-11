class ChangeColumnTosisetuKanribuTeisyutu1 < ActiveRecord::Migration[5.2]

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
        change_column_null :sisetu_kanribu_teisyutu1s, :seikyu_key_link,     flg
        change_column_null :sisetu_kanribu_teisyutu1s, :bango,               flg
        change_column_null :sisetu_kanribu_teisyutu1s, :sisetu_cd,           flg
        change_column_null :sisetu_kanribu_teisyutu1s, :sisetu_nm,           flg
        change_column_null :sisetu_kanribu_teisyutu1s, :yuusyou_kaishi_ym,   flg
        change_column_null :sisetu_kanribu_teisyutu1s, :yuusyou_syuryo_ym,   flg
        change_column_null :sisetu_kanribu_teisyutu1s, :tanka,               flg
        change_column_null :sisetu_kanribu_teisyutu1s, :assen_tesuryo,       flg
        change_column_null :sisetu_kanribu_teisyutu1s, :seikyu_m_su,         flg
        change_column_null :sisetu_kanribu_teisyutu1s, :seikyu_syo_naiyo_ue, flg
        change_column_null :sisetu_kanribu_teisyutu1s, :tokuisaki_cd,        flg
        change_column_null :sisetu_kanribu_teisyutu1s, :seikyu_saki1,        flg
        change_column_null :sisetu_kanribu_teisyutu1s, :siharai_yotei_kbn,   flg
        change_column_null :sisetu_kanribu_teisyutu1s, :siharai_ymd_yokust,  flg
        change_column_null :sisetu_kanribu_teisyutu1s, :siharai_ymd_yokued,  flg
        change_column_null :sisetu_kanribu_teisyutu1s, :ki,                  flg
        change_column_null :sisetu_kanribu_teisyutu1s, :seikyu_m,            flg
        change_column_null :sisetu_kanribu_teisyutu1s, :tantou_cd,           flg
        change_column_null :sisetu_kanribu_teisyutu1s, :shiire_cd,           flg
    end

    # デフォルト値を追加
    def set_default(flg)
        # カラム
        change_column_default :sisetu_kanribu_teisyutu1s, :seikyu_key_link,     flg
        change_column_default :sisetu_kanribu_teisyutu1s, :bango,               flg
        change_column_default :sisetu_kanribu_teisyutu1s, :sisetu_cd,           flg
        change_column_default :sisetu_kanribu_teisyutu1s, :sisetu_nm,           flg
        change_column_default :sisetu_kanribu_teisyutu1s, :yuusyou_kaishi_ym,   flg
        change_column_default :sisetu_kanribu_teisyutu1s, :yuusyou_syuryo_ym,   flg
        change_column_default :sisetu_kanribu_teisyutu1s, :tanka,               0
        change_column_default :sisetu_kanribu_teisyutu1s, :assen_tesuryo,       0
        change_column_default :sisetu_kanribu_teisyutu1s, :seikyu_m_su,         0
        change_column_default :sisetu_kanribu_teisyutu1s, :seikyu_syo_naiyo_ue, flg
        change_column_default :sisetu_kanribu_teisyutu1s, :tokuisaki_cd,        flg
        change_column_default :sisetu_kanribu_teisyutu1s, :seikyu_saki1,        flg
        change_column_default :sisetu_kanribu_teisyutu1s, :siharai_yotei_kbn,   flg
        change_column_default :sisetu_kanribu_teisyutu1s, :siharai_ymd_yokust,  flg
        change_column_default :sisetu_kanribu_teisyutu1s, :siharai_ymd_yokued,  flg
        change_column_default :sisetu_kanribu_teisyutu1s, :ki,                  flg
        change_column_default :sisetu_kanribu_teisyutu1s, :seikyu_m,            flg
        change_column_default :sisetu_kanribu_teisyutu1s, :tantou_cd,           flg
        change_column_default :sisetu_kanribu_teisyutu1s, :shiire_cd,           flg
    end
end
