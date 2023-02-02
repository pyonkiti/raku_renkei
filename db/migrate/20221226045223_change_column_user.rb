class ChangeColumnUser < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default(false);     # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    # Not Null制約を追加
    def set_null(flg)
        change_column_null :users, :name,               flg    # ユーザー名
        change_column_null :users, :name_id,            flg    # ユーザーID
        change_column_null :users, :password_digest,    flg    # パスワード
        change_column_null :users, :admin,              flg    # 管理者フラグ
        change_column_null :users, :created_at,         flg    # 作成日
        change_column_null :users, :updated_at,         flg    # 更新日
    end
    
    # デフォルト値を追加
    def set_default(flg)
        change_column_default :users, :admin,           flg    # 管理者フラグ
    end
end
