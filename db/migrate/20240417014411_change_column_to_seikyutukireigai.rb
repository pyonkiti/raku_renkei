class ChangeColumnToSeikyutukireigai < ActiveRecord::Migration[5.2]
    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    def set_null(flg)
      change_column_null :seikyu_tuki_reigais,  :seikyu_key_link,     flg
      change_column_null :seikyu_tuki_reigais,  :sisetu_nm,           flg
      change_column_null :seikyu_tuki_reigais,  :seikyu_m_su,         flg
      change_column_null :seikyu_tuki_reigais,  :biko_user,           flg
      change_column_null :seikyu_tuki_reigais,  :biko_siyou,          flg
    end

    def set_default(flg)
      change_column_default :seikyu_tuki_reigais,  :seikyu_key_link,   flg
      change_column_default :seikyu_tuki_reigais,  :sisetu_nm,         flg
      change_column_default :seikyu_tuki_reigais,  :seikyu_m_su,       0
      change_column_default :seikyu_tuki_reigais,  :biko_user,         flg
      change_column_default :seikyu_tuki_reigais,  :biko_siyou,        flg
    end
end
