class ChangeColumnCloudRenCheck < ActiveRecord::Migration[5.2]

    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
        change_column_null :cloud_ren_checks,   :dantai_kbn,    flg     # 団体区分
        change_column_null :cloud_ren_checks,   :jichitai_cd,   flg     # 自治体コード
        change_column_null :cloud_ren_checks,   :dantai1,       flg     # 団体名１
        change_column_null :cloud_ren_checks,   :dantai2,       flg     # 団体名２
        change_column_null :cloud_ren_checks,   :bunrui_cd,     flg     # 分類
        change_column_null :cloud_ren_checks,   :bunrui,        flg     # 分類名
        change_column_null :cloud_ren_checks,   :userkey,       flg     # ユーザーキー
        change_column_null :cloud_ren_checks,   :deta_kbn1,     flg     # データ区分１
        change_column_null :cloud_ren_checks,   :deta_kbn2,     flg     # データ区分２
        change_column_null :cloud_ren_checks,   :deta_kbn3,     flg     # データ区分３
        change_column_null :cloud_ren_checks,   :msg,           flg     # メッセージ
    end

    def set_default(flg)
        change_column_default :cloud_ren_checks, :dantai_kbn,   0       # 団体区分
        change_column_default :cloud_ren_checks, :jichitai_cd,  0       # 自治体コード
        change_column_default :cloud_ren_checks, :dantai1,      flg     # 団体名１
        change_column_default :cloud_ren_checks, :dantai2,      flg     # 団体名２
        change_column_default :cloud_ren_checks, :bunrui_cd,    0       # 分類
        change_column_default :cloud_ren_checks, :bunrui,       flg     # 分類名
        change_column_default :cloud_ren_checks, :userkey,      flg     # ユーザーキー
        change_column_default :cloud_ren_checks, :deta_kbn1,    flg     # データ区分１
        change_column_default :cloud_ren_checks, :deta_kbn2,    0       # データ区分２
        change_column_default :cloud_ren_checks, :deta_kbn3,    0       # データ区分３
        change_column_default :cloud_ren_checks, :msg,          flg     # メッセージ
    end
end
