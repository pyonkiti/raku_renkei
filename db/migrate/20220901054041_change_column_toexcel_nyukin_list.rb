class ChangeColumnToexcelNyukinList < ActiveRecord::Migration[5.2]
  
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
        change_column_null :excel_nyukin_lists, :syodan_nm,          flg
        change_column_null :excel_nyukin_lists, :seikyu_no,          flg
        change_column_null :excel_nyukin_lists, :seikyu_ymd,         flg
        change_column_null :excel_nyukin_lists, :torihikisaki_cd,    flg
        change_column_null :excel_nyukin_lists, :seikyusaki_cd,      flg
        change_column_null :excel_nyukin_lists, :seikyusaki_nm,      flg
        change_column_null :excel_nyukin_lists, :nyukin_ymd,         flg
        change_column_null :excel_nyukin_lists, :nyukin_m,           flg
        change_column_null :excel_nyukin_lists, :kon_seikyu_kin,     flg
        change_column_null :excel_nyukin_lists, :kon_syouhizei,      flg
        change_column_null :excel_nyukin_lists, :zeikomi_seikyu_kin, flg
        change_column_null :excel_nyukin_lists, :ki,                 flg
        change_column_null :excel_nyukin_lists, :bumon,              flg
        change_column_null :excel_nyukin_lists, :seikyu_m,           flg
        change_column_null :excel_nyukin_lists, :tantou,             flg
        change_column_null :excel_nyukin_lists, :renban,             flg
        change_column_null :excel_nyukin_lists, :edaban,             flg
        change_column_null :excel_nyukin_lists, :yobi,               flg
        change_column_null :excel_nyukin_lists, :seikyu_key_link,    flg
    end

    # デフォルト値を追加
    def set_default(flg)

        # カラム
        change_column_default :excel_nyukin_lists, :syodan_nm,          flg
        change_column_default :excel_nyukin_lists, :seikyu_no,          flg
        change_column_default :excel_nyukin_lists, :seikyu_ymd,         flg
        change_column_default :excel_nyukin_lists, :torihikisaki_cd,    flg
        change_column_default :excel_nyukin_lists, :seikyusaki_cd,      flg
        change_column_default :excel_nyukin_lists, :seikyusaki_nm,      flg
        change_column_default :excel_nyukin_lists, :nyukin_ymd,         flg
        change_column_default :excel_nyukin_lists, :nyukin_m,           flg
        change_column_default :excel_nyukin_lists, :kon_seikyu_kin,     0
        change_column_default :excel_nyukin_lists, :kon_syouhizei,      0
        change_column_default :excel_nyukin_lists, :zeikomi_seikyu_kin, 0
        change_column_default :excel_nyukin_lists, :ki,                 flg
        change_column_default :excel_nyukin_lists, :bumon,              flg
        change_column_default :excel_nyukin_lists, :seikyu_m,           flg
        change_column_default :excel_nyukin_lists, :tantou,             flg
        change_column_default :excel_nyukin_lists, :renban,             flg
        change_column_default :excel_nyukin_lists, :edaban,             flg
        change_column_default :excel_nyukin_lists, :yobi,               flg
        change_column_default :excel_nyukin_lists, :seikyu_key_link,    flg
    end
end
