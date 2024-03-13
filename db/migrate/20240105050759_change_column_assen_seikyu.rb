class ChangeColumnAssenSeikyu < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
        change_column_null :assen_seikyus,   :shiire_nm,            flg     # 仕入先名
        change_column_null :assen_seikyus,   :kokyaku,              flg     # 顧客名
        change_column_null :assen_seikyus,   :assen_tesuryo,        flg     # 斡旋手数料
        change_column_null :assen_seikyus,   :suuryou,              flg     # 数量
    end

    def set_default(flg)
        change_column_default :assen_seikyus,    :shiire_nm,        flg     # 仕入先名
        change_column_default :assen_seikyus,    :kokyaku,          flg     # 顧客名
        change_column_default :assen_seikyus,    :assen_tesuryo,    0       # 斡旋手数料
        change_column_default :assen_seikyus,    :suuryou,          0       # 数量
    end
end
