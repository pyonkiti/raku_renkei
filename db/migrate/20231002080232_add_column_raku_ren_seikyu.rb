class AddColumnRakuRenSeikyu < ActiveRecord::Migration[5.2]
    def change
        add_column :raku_ren_seikyus, :jido_renban,     :string    # 自動採番
        add_column :raku_ren_seikyus, :dantai_kbn,      :integer   # 団体区分
        add_column :raku_ren_seikyus, :jichitai_cd,     :integer   # 自治体コード
        add_column :raku_ren_seikyus, :todoufuken,      :string    # 都道府県名
        add_column :raku_ren_seikyus, :shikutyouson,    :string    # 市区町村名
        add_column :raku_ren_seikyus, :kigyou_cd,       :integer   # 企業コード
        add_column :raku_ren_seikyus, :kigyou,          :string    # 企業名
        add_column :raku_ren_seikyus, :bunrui,          :string    # 分類名
        add_column :raku_ren_seikyus, :userkey,         :string    # ユーザーキー
        add_index  :raku_ren_seikyus, :userkey
    end
end
