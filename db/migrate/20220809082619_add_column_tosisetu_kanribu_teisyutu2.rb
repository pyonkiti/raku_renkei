class AddColumnTosisetuKanribuTeisyutu2 < ActiveRecord::Migration[5.2]
    def change
        # カラムを追加
        add_column :sisetu_kanribu_teisyutu2s, :shiire_nm,            :string   # 仕入先名
        add_column :sisetu_kanribu_teisyutu2s, :uri_m,                :string   # 売り月
        add_column :sisetu_kanribu_teisyutu2s, :siharai_kikan_cd,     :string   # 支払期間コード
        add_column :sisetu_kanribu_teisyutu2s, :seikyu_basho,         :string   # 請求場所
        add_column :sisetu_kanribu_teisyutu2s, :hakko_flg_seikyu_syo, :string   # 発行フラグ（請求書）
        add_column :sisetu_kanribu_teisyutu2s, :print_flg,            :string   # 印刷フラグ
        add_column :sisetu_kanribu_teisyutu2s, :hasu_kbn_seikyu_gaku, :string   # 端数区分（請求額）
        add_column :sisetu_kanribu_teisyutu2s, :hasu_kbn_syouhizei,   :string   # 端数区分（消費税）
        add_column :sisetu_kanribu_teisyutu2s, :id_user,              :string   # 自動採番（ユーザー）
        add_column :sisetu_kanribu_teisyutu2s, :nyukin_out_flg,       :string   # 入金一覧出力フラグ
        add_column :sisetu_kanribu_teisyutu2s, :created_at,           :datetime # 作成日
    end
end
