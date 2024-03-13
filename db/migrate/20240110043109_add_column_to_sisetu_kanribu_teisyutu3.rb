class AddColumnToSisetuKanribuTeisyutu3 < ActiveRecord::Migration[5.2]
    def change
        add_column :sisetu_kanribu_teisyutu3s,  :todoufuken,           :string   # 都道府県名
        add_column :sisetu_kanribu_teisyutu3s,  :shikutyouson,         :string   # 市区町村名
        add_column :sisetu_kanribu_teisyutu3s,  :kigyou,               :string   # 企業名
        add_column :sisetu_kanribu_teisyutu3s,  :seikyu_saki2,         :string   # 請求先２
        add_column :sisetu_kanribu_teisyutu3s,  :created_at,           :datetime # 作成日
    end
end
