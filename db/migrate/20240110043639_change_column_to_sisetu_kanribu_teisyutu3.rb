class ChangeColumnToSisetuKanribuTeisyutu3 < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
        change_column_null :sisetu_kanribu_teisyutu3s,      :update_raku,   flg     # 更新日
        change_column_null :sisetu_kanribu_teisyutu3s,      :todoufuken,    flg     # 都道府県名
        change_column_null :sisetu_kanribu_teisyutu3s,      :shikutyouson,  flg     # 市区町村名
        change_column_null :sisetu_kanribu_teisyutu3s,      :kigyou,        flg     # 企業名
        change_column_null :sisetu_kanribu_teisyutu3s,      :seikyu_saki2,  flg     # 請求先２
        change_column_null :sisetu_kanribu_teisyutu3s,      :bunrui,        flg     # 分類名
    end

    def set_default(flg)
        change_column_default :sisetu_kanribu_teisyutu3s,   :update_raku,   flg     # 更新日
        change_column_default :sisetu_kanribu_teisyutu3s,   :todoufuken,    flg     # 都道府県名
        change_column_default :sisetu_kanribu_teisyutu3s,   :shikutyouson,  flg     # 市区町村名
        change_column_default :sisetu_kanribu_teisyutu3s,   :kigyou,        flg     # 企業名
        change_column_default :sisetu_kanribu_teisyutu3s,   :seikyu_saki2,  flg     # 請求先２
        change_column_default :sisetu_kanribu_teisyutu3s,   :bunrui,        flg     # 分類名
    end
end
