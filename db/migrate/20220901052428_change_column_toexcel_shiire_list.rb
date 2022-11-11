class ChangeColumnToexcelShiireList < ActiveRecord::Migration[5.2]
  
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
        change_column_null :excel_shiire_lists, :denpyo_kugiri,   flg
        change_column_null :excel_shiire_lists, :hojyo_kamoku,    flg
        change_column_null :excel_shiire_lists, :torihikisaki,    flg
        change_column_null :excel_shiire_lists, :tekiyo1,         flg
        change_column_null :excel_shiire_lists, :tekiyo2,         flg
        change_column_null :excel_shiire_lists, :tekiyo3,         flg
        change_column_null :excel_shiire_lists, :biko,            flg
        change_column_null :excel_shiire_lists, :kingaku,         flg
        change_column_null :excel_shiire_lists, :zei,             flg
        change_column_null :excel_shiire_lists, :bumon,           flg
        change_column_null :excel_shiire_lists, :kasikata_kamoku, flg
        change_column_null :excel_shiire_lists, :syouhizei,       flg
        change_column_null :excel_shiire_lists, :gokei_kingaku,   flg
        change_column_null :excel_shiire_lists, :kaikake_kin,     flg
        change_column_null :excel_shiire_lists, :hizuke,          flg
        change_column_null :excel_shiire_lists, :torihikisaki_c,  flg
        change_column_null :excel_shiire_lists, :seikyu_key_link, flg
    end

    # デフォルト値を追加
    def set_default(flg)
        # カラム
        change_column_default :excel_shiire_lists, :denpyo_kugiri,   flg
        change_column_default :excel_shiire_lists, :hojyo_kamoku,    flg
        change_column_default :excel_shiire_lists, :torihikisaki,    flg
        change_column_default :excel_shiire_lists, :tekiyo1,         flg
        change_column_default :excel_shiire_lists, :tekiyo2,         flg
        change_column_default :excel_shiire_lists, :tekiyo3,         flg
        change_column_default :excel_shiire_lists, :biko,            flg
        change_column_default :excel_shiire_lists, :kingaku,         0
        change_column_default :excel_shiire_lists, :zei,             0
        change_column_default :excel_shiire_lists, :bumon,           flg
        change_column_default :excel_shiire_lists, :kasikata_kamoku, flg
        change_column_default :excel_shiire_lists, :syouhizei,       0
        change_column_default :excel_shiire_lists, :gokei_kingaku,   0
        change_column_default :excel_shiire_lists, :kaikake_kin,     flg
        change_column_default :excel_shiire_lists, :hizuke,          flg
        change_column_default :excel_shiire_lists, :torihikisaki_c,  flg
        change_column_default :excel_shiire_lists, :seikyu_key_link, flg
    end
end
