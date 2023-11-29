class ChangeColumnCloudRenUser < ActiveRecord::Migration[5.2]
  
    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    # Not Null制約を追加
    def set_null(flg)
        change_column_null :cloud_ren_users, :userkey,          flg     # ユーザーキー
        change_column_null :cloud_ren_users, :pseudokey,        flg     # ？
        change_column_null :cloud_ren_users, :remark,           flg     # ユーザー名
        change_column_null :cloud_ren_users, :db_ip,            flg     # IPアドレス
        change_column_null :cloud_ren_users, :port,             flg     # ポート番号
        change_column_null :cloud_ren_users, :almrcv_port,      flg     # アラームポート番号
        change_column_null :cloud_ren_users, :command_port,     flg     # コマンドポート番号
    end

    # デフォルト値を追加
    def set_default(flg)
        change_column_default :cloud_ren_users, :userkey,       flg     # ユーザーキー
        change_column_default :cloud_ren_users, :pseudokey,     flg     # ？
        change_column_default :cloud_ren_users, :remark,        flg     # ユーザー名
        change_column_default :cloud_ren_users, :db_ip,         flg     # IPアドレス
        change_column_default :cloud_ren_users, :port,          flg     # ポート番号
        change_column_default :cloud_ren_users, :almrcv_port,   flg     # アラームポート番号
        change_column_default :cloud_ren_users, :command_port,  flg     # コマンドポート番号
    end
end
