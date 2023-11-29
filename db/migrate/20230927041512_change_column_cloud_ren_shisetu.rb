class ChangeColumnCloudRenShisetu < ActiveRecord::Migration[5.2]
  
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
        change_column_default :cloud_ren_shisetus, :userkey,          flg     # ユーザーキー
        change_column_default :cloud_ren_shisetus, :f_scode,          flg     # 施設コード
        change_column_default :cloud_ren_shisetus, :f_ttype,          flg     # Tタイプ
        change_column_default :cloud_ren_shisetus, :f_sname,          flg     # 施設名
        change_column_default :cloud_ren_shisetus, :f_connect,        flg     # 接続
        change_column_default :cloud_ren_shisetus, :f_ip,             flg     # IPアドレス
    end

    # デフォルト値を追加
    def set_default(flg)
        change_column_default :cloud_ren_shisetus, :userkey,          flg     # ユーザーキー
        change_column_default :cloud_ren_shisetus, :f_scode,          0       # 施設コード
        change_column_default :cloud_ren_shisetus, :f_ttype,          flg     # Tタイプ
        change_column_default :cloud_ren_shisetus, :f_sname,          flg     # 施設名
        change_column_default :cloud_ren_shisetus, :f_connect,        flg     # 接続
        change_column_default :cloud_ren_shisetus, :f_ip,             flg     # IPアドレス
    end
end
