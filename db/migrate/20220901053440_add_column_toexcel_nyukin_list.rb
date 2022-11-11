class AddColumnToexcelNyukinList < ActiveRecord::Migration[5.2]

    def change

        # カラムを追加
        add_column :excel_nyukin_lists, :syodan_nm,          :string  # 商談名
        add_column :excel_nyukin_lists, :seikyu_no,          :string  # 請求No
        add_column :excel_nyukin_lists, :seikyu_ymd,         :string  # 請求年月日
        add_column :excel_nyukin_lists, :torihikisaki_cd,    :string  # 取引先コード
        add_column :excel_nyukin_lists, :seikyusaki_cd,      :string  # 請求先コード
        add_column :excel_nyukin_lists, :seikyusaki_nm,      :string  # 請求先名称
        add_column :excel_nyukin_lists, :nyukin_ymd,         :string  # 入金年月日
        add_column :excel_nyukin_lists, :nyukin_m,           :string  # 入金月
        add_column :excel_nyukin_lists, :kon_seikyu_kin,     :integer # 今回請求金額
        add_column :excel_nyukin_lists, :kon_syouhizei,      :integer # 今回消費税
        add_column :excel_nyukin_lists, :zeikomi_seikyu_kin, :integer # 税込請求金額
        add_column :excel_nyukin_lists, :ki,                 :string  # 期
        add_column :excel_nyukin_lists, :bumon,              :string  # 部門
        add_column :excel_nyukin_lists, :seikyu_m,           :string  # 請求月
        add_column :excel_nyukin_lists, :tantou,             :string  # 担当者
        add_column :excel_nyukin_lists, :renban,             :string  # 連番
        add_column :excel_nyukin_lists, :edaban,             :string  # 枝番
        add_column :excel_nyukin_lists, :yobi,               :string  # 予備
        add_column :excel_nyukin_lists, :seikyu_key_link,    :string  # 請求キーリンク
  end
end
