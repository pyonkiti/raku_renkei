class AddColumnToseikyuYoteCal < ActiveRecord::Migration[5.2]

    def change
        # カラムを追加
        add_column :seikyu_yote_cals, :seikyu_ym,           :string     # 請求年月
        add_column :seikyu_yote_cals, :seikyu_kin,          :integer    # 請求額合計
        add_column :seikyu_yote_cals, :assen_tesuryo,       :integer    # 斡旋手数料合計
  end
end
