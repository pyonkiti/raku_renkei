class AddColumnAssenSeikyu < ActiveRecord::Migration[5.2]
    def change
        add_column :assen_seikyus,      :shiire_nm,     :string     # 仕入先名
        add_column :assen_seikyus,      :kokyaku,       :string     # 顧客名
        add_column :assen_seikyus,      :assen_tesuryo, :integer    # 斡旋手数料
        add_column :assen_seikyus,      :suuryou,       :integer    # 数量
    end
end
