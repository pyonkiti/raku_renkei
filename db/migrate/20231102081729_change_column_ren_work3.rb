class ChangeColumnRenWork3 < ActiveRecord::Migration[5.2]
  
    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
        change_column_default :cloud_ren_work3s, :seikyu_keylink,   flg     # 請求キーリンク
        change_column_default :cloud_ren_work3s, :userkey,          flg     # ユーザーキー
        change_column_default :cloud_ren_work3s, :f_scode,          flg     # 施設コード
        change_column_default :cloud_ren_work3s, :f_sname,          flg     # 施設名
        change_column_default :cloud_ren_work3s, :dantai_kbn,       flg     # 団体区分
        change_column_default :cloud_ren_work3s, :jichitai_cd,      flg     # 自治体コード
        change_column_default :cloud_ren_work3s, :dantai1,          flg     # 団体名１
        change_column_default :cloud_ren_work3s, :dantai2,          flg     # 団体名２
        change_column_default :cloud_ren_work3s, :bunrui,           flg     # 分類名
        change_column_default :cloud_ren_work3s, :deta_kbn1,        flg     # データ区分１
        change_column_default :cloud_ren_work3s, :deta_kbn2,        flg     # データ区分２
    end

    def set_default(flg)
        change_column_default :cloud_ren_work3s, :seikyu_keylink,   flg     # 請求キーリンク
        change_column_default :cloud_ren_work3s, :userkey,          flg     # ユーザーキー
        change_column_default :cloud_ren_work3s, :f_scode,          flg     # 施設コード
        change_column_default :cloud_ren_work3s, :f_sname,          flg     # 施設名
        change_column_default :cloud_ren_work3s, :dantai_kbn,       0       # 団体区分
        change_column_default :cloud_ren_work3s, :jichitai_cd,      0       # 自治体コード
        change_column_default :cloud_ren_work3s, :dantai1,          flg     # 団体名１
        change_column_default :cloud_ren_work3s, :dantai2,          flg     # 団体名２
        change_column_default :cloud_ren_work3s, :bunrui,           flg     # 分類名
        change_column_default :cloud_ren_work3s, :deta_kbn1,        flg     # データ区分１
        change_column_default :cloud_ren_work3s, :deta_kbn2,        0       # データ区分２
    end

end
