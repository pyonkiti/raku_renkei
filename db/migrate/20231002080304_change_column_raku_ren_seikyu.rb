class ChangeColumnRakuRenSeikyu < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
        change_column_null  :raku_ren_seikyus,  :jido_renban,   flg     # 自動採番
        change_column_null  :raku_ren_seikyus,  :dantai_kbn,    flg     # 団体区分
        change_column_null  :raku_ren_seikyus,  :jichitai_cd,   flg     # 自治体コード
        change_column_null  :raku_ren_seikyus,  :todoufuken,    flg     # 都道府県名
        change_column_null  :raku_ren_seikyus,  :shikutyouson,  flg     # 市区町村名
        change_column_null  :raku_ren_seikyus,  :kigyou_cd,     flg     # 企業コード
        change_column_null  :raku_ren_seikyus,  :kigyou,        flg     # 企業名
        change_column_null  :raku_ren_seikyus,  :bunrui,        flg     # 分類名
        change_column_null  :raku_ren_seikyus,  :userkey,       flg     # ユーザーキー
    end

    def set_default(flg)
        change_column_default :raku_ren_seikyus, :jido_renban,  flg     # 自動採番
        change_column_default :raku_ren_seikyus, :dantai_kbn,   0       # 団体区分
        change_column_default :raku_ren_seikyus, :jichitai_cd,  0       # 自治体コード
        change_column_default :raku_ren_seikyus, :todoufuken,   flg     # 都道府県名
        change_column_default :raku_ren_seikyus, :shikutyouson, flg     # 市区町村名
        change_column_default :raku_ren_seikyus, :kigyou_cd,    0       # 企業コード
        change_column_default :raku_ren_seikyus, :kigyou,       flg     # 企業名
        change_column_default :raku_ren_seikyus, :bunrui,       flg     # 分類名
        change_column_default :raku_ren_seikyus, :userkey,      flg     # ユーザーキー
    end
end
