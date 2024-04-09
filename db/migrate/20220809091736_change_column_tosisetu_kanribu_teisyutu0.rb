class ChangeColumnTosisetuKanribuTeisyutu0 < ActiveRecord::Migration[5.2]

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
        # カラム（テーブル１より連携）
        change_column_null :sisetu_kanribu_teisyutu0s, :update_raku,         flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_key_link,     flg
        change_column_null :sisetu_kanribu_teisyutu0s, :bango,               flg
        change_column_null :sisetu_kanribu_teisyutu0s, :sisetu_cd,           flg
        change_column_null :sisetu_kanribu_teisyutu0s, :sisetu_nm,           flg
        change_column_null :sisetu_kanribu_teisyutu0s, :yuusyou_kaishi_ym,   flg
        change_column_null :sisetu_kanribu_teisyutu0s, :yuusyou_syuryo_ym,   flg
        change_column_null :sisetu_kanribu_teisyutu0s, :tanka,               flg
        change_column_null :sisetu_kanribu_teisyutu0s, :assen_tesuryo,       flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_m_su,         flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_syo_naiyo_ue, flg
        change_column_null :sisetu_kanribu_teisyutu0s, :tokuisaki_cd,        flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_saki1,        flg
        change_column_null :sisetu_kanribu_teisyutu0s, :siharai_yotei_kbn,   flg
        change_column_null :sisetu_kanribu_teisyutu0s, :siharai_ymd_yokust,  flg
        change_column_null :sisetu_kanribu_teisyutu0s, :siharai_ymd_yokued,  flg
        change_column_null :sisetu_kanribu_teisyutu0s, :ki,                  flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_m,            flg
        change_column_null :sisetu_kanribu_teisyutu0s, :tantou_cd,           flg
        change_column_null :sisetu_kanribu_teisyutu0s, :shiire_cd,           flg

        # カラム（テーブル２より連携）
        change_column_null :sisetu_kanribu_teisyutu0s, :shiire_nm,            flg
        change_column_null :sisetu_kanribu_teisyutu0s, :uri_m,                flg
        change_column_null :sisetu_kanribu_teisyutu0s, :siharai_kikan_cd,     flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_basho,         flg
        change_column_null :sisetu_kanribu_teisyutu0s, :hakko_flg_seikyu_syo, flg
        change_column_null :sisetu_kanribu_teisyutu0s, :print_flg,            flg
        change_column_null :sisetu_kanribu_teisyutu0s, :hasu_kbn_seikyu_gaku, flg
        change_column_null :sisetu_kanribu_teisyutu0s, :hasu_kbn_syouhizei,   flg
        change_column_null :sisetu_kanribu_teisyutu0s, :id_user,              flg
        change_column_null :sisetu_kanribu_teisyutu0s, :nyukin_out_flg,       flg

        # カラム（テーブル３より連携）
        change_column_null :sisetu_kanribu_teisyutu0s, :todoufuken,           flg
        change_column_null :sisetu_kanribu_teisyutu0s, :shikutyouson,         flg
        change_column_null :sisetu_kanribu_teisyutu0s, :kigyou,               flg
        change_column_null :sisetu_kanribu_teisyutu0s, :seikyu_saki2,         flg
        change_column_null :sisetu_kanribu_teisyutu0s, :bunrui,               flg
    end

    # デフォルト値を追加
    def set_default(flg)
        # カラム（テーブル１より連携）
        change_column_default :sisetu_kanribu_teisyutu0s, :update_raku,         flg
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_key_link,     flg
        change_column_default :sisetu_kanribu_teisyutu0s, :bango,               flg
        change_column_default :sisetu_kanribu_teisyutu0s, :sisetu_cd,           flg
        change_column_default :sisetu_kanribu_teisyutu0s, :sisetu_nm,           flg
        change_column_default :sisetu_kanribu_teisyutu0s, :yuusyou_kaishi_ym,   flg
        change_column_default :sisetu_kanribu_teisyutu0s, :yuusyou_syuryo_ym,   flg
        change_column_default :sisetu_kanribu_teisyutu0s, :tanka,               0
        change_column_default :sisetu_kanribu_teisyutu0s, :assen_tesuryo,       0
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_m_su,         0
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_syo_naiyo_ue, flg
        change_column_default :sisetu_kanribu_teisyutu0s, :tokuisaki_cd,        flg
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_saki1,        flg
        change_column_default :sisetu_kanribu_teisyutu0s, :siharai_yotei_kbn,   flg
        change_column_default :sisetu_kanribu_teisyutu0s, :siharai_ymd_yokust,  flg
        change_column_default :sisetu_kanribu_teisyutu0s, :siharai_ymd_yokued,  flg
        change_column_default :sisetu_kanribu_teisyutu0s, :ki,                  flg
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_m,            flg
        change_column_default :sisetu_kanribu_teisyutu0s, :tantou_cd,           flg
        change_column_default :sisetu_kanribu_teisyutu0s, :shiire_cd,           flg

        # カラム（テーブル２より連携）
        change_column_default :sisetu_kanribu_teisyutu0s, :shiire_nm,            flg
        change_column_default :sisetu_kanribu_teisyutu0s, :uri_m,                flg
        change_column_default :sisetu_kanribu_teisyutu0s, :siharai_kikan_cd,     flg
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_basho,         flg
        change_column_default :sisetu_kanribu_teisyutu0s, :hakko_flg_seikyu_syo, flg
        change_column_default :sisetu_kanribu_teisyutu0s, :print_flg,            flg
        change_column_default :sisetu_kanribu_teisyutu0s, :hasu_kbn_seikyu_gaku, flg
        change_column_default :sisetu_kanribu_teisyutu0s, :hasu_kbn_syouhizei,   flg
        change_column_default :sisetu_kanribu_teisyutu0s, :id_user,              flg
        change_column_default :sisetu_kanribu_teisyutu0s, :nyukin_out_flg,       flg

        # カラム（テーブル３より連携）
        change_column_default :sisetu_kanribu_teisyutu0s, :todoufuken,           flg
        change_column_default :sisetu_kanribu_teisyutu0s, :shikutyouson,         flg
        change_column_default :sisetu_kanribu_teisyutu0s, :kigyou,               flg
        change_column_default :sisetu_kanribu_teisyutu0s, :seikyu_saki2,         flg
        change_column_default :sisetu_kanribu_teisyutu0s, :bunrui,               flg
    end
end
