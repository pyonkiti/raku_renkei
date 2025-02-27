class ChangeColumnToCloudRenBuzzer < ActiveRecord::Migration[5.2]
  def up
      set_null(false);        # Not Null制約をセット
      set_default("");        # デフォルト値をセット
  end

  def down
      set_null(true);         # Not Null制約を除去
      set_default(nil);       # デフォルト値を除去
  end

  def set_null(flg)
      change_column_null :cloud_ren_buzzers,    :userkey,           flg     # ユーザーキー
      change_column_null :cloud_ren_buzzers,    :buzzer_id,         flg     # ブザーID
      change_column_null :cloud_ren_buzzers,    :buzzer_name,       flg     # ブザー名
      change_column_null :cloud_ren_buzzers,    :upd_flg,           flg     # 更新フラグ
      change_column_null :cloud_ren_buzzers,    :sts_flg,           flg     # 状態フラグ
  end

  def set_default(flg)
      change_column_default :cloud_ren_buzzers,  :userkey,          flg     # ユーザーキー
      change_column_default :cloud_ren_buzzers,  :buzzer_id,        flg     # ブザーID
      change_column_default :cloud_ren_buzzers,  :buzzer_name,      flg     # ブザー名
      change_column_default :cloud_ren_buzzers,  :upd_flg,          flg     # 更新フラグ
      change_column_default :cloud_ren_buzzers,  :sts_flg,          0       # 状態フラグ
  end
end
