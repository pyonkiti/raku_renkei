class ChangeColumnTosisetuKanribuTeisyutu2 < ActiveRecord::Migration[5.2]
  
    # Not Null制約を追加
    def up
        set_null(false);        # Not Null制約をセット
        set_default("");        # デフォルト値をセット
    end

    # デフォルト値を追加
    def down
        set_null(true);         # Not Null制約を除去
        set_default(nil);       # デフォルト値を除去
    end

    # Not Null制約を追加
    def set_null(flg)
        # カラム
        change_column_null :sisetu_kanribu_teisyutu2s, :shiire_nm,            flg
        change_column_null :sisetu_kanribu_teisyutu2s, :uri_m,                flg
        change_column_null :sisetu_kanribu_teisyutu2s, :siharai_kikan_cd,     flg
        change_column_null :sisetu_kanribu_teisyutu2s, :seikyu_basho,         flg
        change_column_null :sisetu_kanribu_teisyutu2s, :hakko_flg_seikyu_syo, flg
        change_column_null :sisetu_kanribu_teisyutu2s, :print_flg,            flg
        change_column_null :sisetu_kanribu_teisyutu2s, :hasu_kbn_seikyu_gaku, flg
        change_column_null :sisetu_kanribu_teisyutu2s, :hasu_kbn_syouhizei,   flg
        change_column_null :sisetu_kanribu_teisyutu2s, :id_user,              flg
        change_column_null :sisetu_kanribu_teisyutu2s, :nyukin_out_flg,       flg
    end

    # デフォルト値を追加
    def set_default(flg)
        # カラム
        change_column_default :sisetu_kanribu_teisyutu2s, :shiire_nm,            flg
        change_column_default :sisetu_kanribu_teisyutu2s, :uri_m,                flg
        change_column_default :sisetu_kanribu_teisyutu2s, :siharai_kikan_cd,     flg
        change_column_default :sisetu_kanribu_teisyutu2s, :seikyu_basho,         flg
        change_column_default :sisetu_kanribu_teisyutu2s, :hakko_flg_seikyu_syo, flg
        change_column_default :sisetu_kanribu_teisyutu2s, :print_flg,            flg
        change_column_default :sisetu_kanribu_teisyutu2s, :hasu_kbn_seikyu_gaku, flg
        change_column_default :sisetu_kanribu_teisyutu2s, :hasu_kbn_syouhizei,   flg
        change_column_default :sisetu_kanribu_teisyutu2s, :id_user,              flg
        change_column_default :sisetu_kanribu_teisyutu2s, :nyukin_out_flg,       flg
    end
end
