class ChangeColumnTotest1 < ActiveRecord::Migration[5.2]
  
    def up
        change_column_default :test01s, :name2, ""
        change_column_null    :test01s, :name3, false

        change_column_default :test01s, :name4, ""
        change_column_null    :test01s, :name4, false
    end

    def down
        change_column_default :test01s, :name2, nil
        change_column_null    :test01s, :name3, true

        change_column_default :test01s, :name4, nil
        change_column_null    :test01s, :name4, true
    end
end
