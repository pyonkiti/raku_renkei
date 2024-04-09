class AddColumnTosisetuKanribuTeisyutu1 < ActiveRecord::Migration[5.2]
    def change
        add_column :sisetu_kanribu_teisyutu1s, :update_raku,         :datetime # 更新日
        add_column :sisetu_kanribu_teisyutu1s, :seikyu_key_link,     :string   # 請求キーリンク
        add_column :sisetu_kanribu_teisyutu1s, :bango,               :string   # 番号
        add_column :sisetu_kanribu_teisyutu1s, :sisetu_cd,           :integer  # 施設コード
        add_column :sisetu_kanribu_teisyutu1s, :sisetu_nm,           :string   # 施設名
        add_column :sisetu_kanribu_teisyutu1s, :yuusyou_kaishi_ym,   :string   # 有償開始年月
        add_column :sisetu_kanribu_teisyutu1s, :yuusyou_syuryo_ym,   :string   # 有償終了年月
        add_column :sisetu_kanribu_teisyutu1s, :tanka,               :integer  # 単価
        add_column :sisetu_kanribu_teisyutu1s, :assen_tesuryo,       :integer  # 斡旋手数料
        add_column :sisetu_kanribu_teisyutu1s, :seikyu_m_su,         :integer  # 請求月数
        add_column :sisetu_kanribu_teisyutu1s, :seikyu_syo_naiyo_ue, :string   # 請求書内容（上段）
        add_column :sisetu_kanribu_teisyutu1s, :tokuisaki_cd,        :string   # 得意先コード
        add_column :sisetu_kanribu_teisyutu1s, :seikyu_saki1,        :string   # 請求先１
        add_column :sisetu_kanribu_teisyutu1s, :siharai_yotei_kbn,   :string   # 支払予定日区分
        add_column :sisetu_kanribu_teisyutu1s, :siharai_ymd_yokust,  :string   # 支払日（翌月初）
        add_column :sisetu_kanribu_teisyutu1s, :siharai_ymd_yokued,  :string   # 支払日（翌月末）
        add_column :sisetu_kanribu_teisyutu1s, :ki,                  :string   # 期
        add_column :sisetu_kanribu_teisyutu1s, :seikyu_m,            :string   # 請求月
        add_column :sisetu_kanribu_teisyutu1s, :tantou_cd,           :string   # 担当者コード
        add_column :sisetu_kanribu_teisyutu1s, :shiire_cd,           :string   # 仕入先コード
        add_column :sisetu_kanribu_teisyutu1s, :created_at,          :datetime # 作成日
    end
end
