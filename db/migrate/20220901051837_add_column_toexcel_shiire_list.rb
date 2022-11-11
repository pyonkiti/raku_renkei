class AddColumnToexcelShiireList < ActiveRecord::Migration[5.2]
  
    def change
        # カラムを追加
        add_column :excel_shiire_lists, :denpyo_kugiri,   :string  # 伝票区切
        add_column :excel_shiire_lists, :hojyo_kamoku,    :string  # 補助科目
        add_column :excel_shiire_lists, :torihikisaki,    :string  # 取引先
        add_column :excel_shiire_lists, :tekiyo1,         :string  # 適用（１）
        add_column :excel_shiire_lists, :tekiyo2,         :string  # 適用（２）
        add_column :excel_shiire_lists, :tekiyo3,         :string  # 適用（３）
        add_column :excel_shiire_lists, :biko,            :string  # 備考
        add_column :excel_shiire_lists, :kingaku,         :integer # 金額
        add_column :excel_shiire_lists, :zei,             :integer # 税
        add_column :excel_shiire_lists, :bumon,           :string  # 部門
        add_column :excel_shiire_lists, :kasikata_kamoku, :string  # 借方科目
        add_column :excel_shiire_lists, :syouhizei,       :integer # 消費税
        add_column :excel_shiire_lists, :gokei_kingaku,   :integer # 合計金額
        add_column :excel_shiire_lists, :kaikake_kin,     :string  # 買掛金
        add_column :excel_shiire_lists, :hizuke,          :string  # 日付
        add_column :excel_shiire_lists, :torihikisaki_c,  :string  # 取引先C
        add_column :excel_shiire_lists, :seikyu_key_link, :string  # 請求キーリンク
  end
end
