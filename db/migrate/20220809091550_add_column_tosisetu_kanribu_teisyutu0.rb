class AddColumnTosisetuKanribuTeisyutu0 < ActiveRecord::Migration[5.2]

    def change

        # カラムを追加（テーブル１より連携）
        add_column :sisetu_kanribu_teisyutu0s, :update_raku,         :datetime  # 更新日
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_key_link,     :string    # 請求キーリンク
        add_column :sisetu_kanribu_teisyutu0s, :bango,               :string    # 番号
        add_column :sisetu_kanribu_teisyutu0s, :sisetu_cd,           :integer   # 施設コード
        add_column :sisetu_kanribu_teisyutu0s, :sisetu_nm,           :string    # 施設名
        add_column :sisetu_kanribu_teisyutu0s, :yuusyou_kaishi_ym,   :string    # 有償開始年月
        add_column :sisetu_kanribu_teisyutu0s, :yuusyou_syuryo_ym,   :string    # 有償終了年月
        add_column :sisetu_kanribu_teisyutu0s, :tanka,               :integer   # 単価
        add_column :sisetu_kanribu_teisyutu0s, :assen_tesuryo,       :integer   # 斡旋手数料
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_m_su,         :integer   # 請求月数
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_syo_naiyo_ue, :string    # 請求書内容（上段）
        add_column :sisetu_kanribu_teisyutu0s, :tokuisaki_cd,        :string    # 得意先コード
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_saki1,        :string    # 請求先１
        add_column :sisetu_kanribu_teisyutu0s, :siharai_yotei_kbn,   :string    # 支払予定日区分
        add_column :sisetu_kanribu_teisyutu0s, :siharai_ymd_yokust,  :string    # 支払日（翌月初）
        add_column :sisetu_kanribu_teisyutu0s, :siharai_ymd_yokued,  :string    # 支払日（翌月末）
        add_column :sisetu_kanribu_teisyutu0s, :ki,                  :string    # 期
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_m,            :string    # 請求月
        add_column :sisetu_kanribu_teisyutu0s, :tantou_cd,           :string    # 担当者コード
        add_column :sisetu_kanribu_teisyutu0s, :shiire_cd,           :string    # 仕入先コード

        # カラムを追加（テーブル２より連携）
        add_column :sisetu_kanribu_teisyutu0s, :shiire_nm,            :string   # 仕入先名
        add_column :sisetu_kanribu_teisyutu0s, :uri_m,                :string   # 売り月
        add_column :sisetu_kanribu_teisyutu0s, :siharai_kikan_cd,     :string   # 支払期間コード
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_basho,         :string   # 請求場所
        add_column :sisetu_kanribu_teisyutu0s, :hakko_flg_seikyu_syo, :string   # 発行フラグ（請求書）
        add_column :sisetu_kanribu_teisyutu0s, :print_flg,            :string   # 印刷フラグ
        add_column :sisetu_kanribu_teisyutu0s, :hasu_kbn_seikyu_gaku, :string   # 端数区分（請求額）
        add_column :sisetu_kanribu_teisyutu0s, :hasu_kbn_syouhizei,   :string   # 端数区分（消費税）
        add_column :sisetu_kanribu_teisyutu0s, :id_user,              :string   # 自動採番（ユーザー）
        add_column :sisetu_kanribu_teisyutu0s, :nyukin_out_flg,       :string   # 入金一覧出力フラグ

        # カラムを追加（テーブル３より連携）
        add_column :sisetu_kanribu_teisyutu0s, :todoufuken,          :string   # 都道府県名
        add_column :sisetu_kanribu_teisyutu0s, :shikutyouson,        :string   # 市区町村名
        add_column :sisetu_kanribu_teisyutu0s, :kigyou,              :string   # 企業名
        add_column :sisetu_kanribu_teisyutu0s, :seikyu_saki2,        :string   # 請求先２
        add_column :sisetu_kanribu_teisyutu0s, :bunrui,              :string   # 分類名
        add_column :sisetu_kanribu_teisyutu0s, :created_at,          :datetime # 作成日
    end
end
