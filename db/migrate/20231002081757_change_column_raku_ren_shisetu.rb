class ChangeColumnRakuRenShisetu < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
        change_column_default :raku_ren_shisetus, :seikyu_keylink,   flg     # 請求キーリンク
        change_column_default :raku_ren_shisetus, :bango,            flg     # 番号
        change_column_default :raku_ren_shisetus, :shisetu,          flg     # 施設名
        change_column_default :raku_ren_shisetus, :shisetu_cd,       flg     # 施設コード
        change_column_default :raku_ren_shisetus, :userkey,          flg     # ユーザーキー
    end

    def set_default(flg)
        change_column_default :raku_ren_shisetus, :seikyu_keylink,   flg     # 請求キーリンク
        change_column_default :raku_ren_shisetus, :bango,            flg     # 番号
        change_column_default :raku_ren_shisetus, :shisetu,          flg     # 施設名
        change_column_default :raku_ren_shisetus, :shisetu_cd,       0       # 施設コード
        change_column_default :raku_ren_shisetus, :userkey,          flg     # ユーザーキー
    end
end
