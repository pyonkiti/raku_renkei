class ChangeColumnToseikyuYoteCal < ActiveRecord::Migration[5.2]
  
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
        change_column_null :seikyu_yote_cals, :seikyu_ym,           flg    # 請求年月
        change_column_null :seikyu_yote_cals, :seikyu_kin,          flg    # 請求額合計
        change_column_null :seikyu_yote_cals, :assen_tesuryo,       flg    # 斡旋手数料合計
    end

    # デフォルト値を追加
    def set_default(flg)

        # カラム
        change_column_default :seikyu_yote_cals, :seikyu_ym,           flg # 請求年月
        change_column_default :seikyu_yote_cals, :seikyu_kin,          0   # 請求額合計
        change_column_default :seikyu_yote_cals, :assen_tesuryo,       0   # 斡旋手数料合計
    end
end
