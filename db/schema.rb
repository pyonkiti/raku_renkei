# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_02_12_023345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assen_seikyus", force: :cascade do |t|
    t.string "shiire_nm", default: "", null: false
    t.string "kokyaku", default: "", null: false
    t.integer "assen_tesuryo", default: 0, null: false
    t.integer "suuryou", default: 0, null: false
  end

  create_table "cloud_ren_buzzers", force: :cascade do |t|
    t.string "userkey", default: "", null: false
    t.string "buzzer_id", default: "", null: false
    t.string "buzzer_name", default: "", null: false
    t.string "upd_flg", default: "", null: false
    t.integer "sts_flg", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cloud_ren_checks", force: :cascade do |t|
    t.integer "dantai_kbn", default: 0, null: false
    t.integer "jichitai_cd", default: 0, null: false
    t.string "dantai1", default: "", null: false
    t.string "dantai2", default: "", null: false
    t.integer "bunrui_cd", default: 0, null: false
    t.string "bunrui", default: "", null: false
    t.string "userkey", default: "", null: false
    t.string "deta_kbn1", default: "", null: false
    t.integer "deta_kbn2", default: 0, null: false
    t.integer "deta_kbn3", default: 0, null: false
    t.string "msg", default: "", null: false
    t.datetime "created_at"
    t.index ["userkey"], name: "index_cloud_ren_checks_on_userkey"
  end

  create_table "cloud_ren_shisetus", force: :cascade do |t|
    t.string "userkey", default: "", null: false
    t.integer "f_scode", default: 0, null: false
    t.string "f_ttype", default: "", null: false
    t.string "f_sname", default: "", null: false
    t.string "f_connect", default: "", null: false
    t.string "f_ip", default: "", null: false
    t.datetime "created_at"
    t.index ["f_scode", "userkey"], name: "index_cloud_ren_shisetus_on_f_scode_and_userkey"
  end

  create_table "cloud_ren_users", force: :cascade do |t|
    t.string "userkey", default: "", null: false
    t.string "pseudokey", default: "", null: false
    t.string "remark", default: "", null: false
    t.string "db_ip", default: "", null: false
    t.string "port", default: "", null: false
    t.string "almrcv_port", default: "", null: false
    t.string "command_port", default: "", null: false
    t.datetime "created_at"
    t.index ["userkey"], name: "index_cloud_ren_users_on_userkey"
  end

  create_table "cloud_ren_work3s", force: :cascade do |t|
    t.string "seikyu_keylink", default: "", null: false
    t.string "userkey", default: "", null: false
    t.string "f_scode", default: "", null: false
    t.string "f_sname", default: "", null: false
    t.integer "dantai_kbn", default: 0, null: false
    t.integer "jichitai_cd", default: 0, null: false
    t.string "dantai1", default: "", null: false
    t.string "dantai2", default: "", null: false
    t.string "bunrui", default: "", null: false
    t.string "deta_kbn1", default: "", null: false
    t.integer "deta_kbn2", default: 0, null: false
    t.index ["seikyu_keylink", "userkey"], name: "index_cloud_ren_work3s_on_seikyu_keylink_and_userkey"
  end

  create_table "excel_nyukin_lists", force: :cascade do |t|
    t.string "syodan_nm", default: "", null: false
    t.string "seikyu_no", default: "", null: false
    t.string "seikyu_ymd", default: "", null: false
    t.string "torihikisaki_cd", default: "", null: false
    t.string "seikyusaki_cd", default: "", null: false
    t.string "seikyusaki_nm", default: "", null: false
    t.string "nyukin_ymd", default: "", null: false
    t.string "nyukin_m", default: "", null: false
    t.integer "kon_seikyu_kin", default: 0, null: false
    t.integer "kon_syouhizei", default: 0, null: false
    t.integer "zeikomi_seikyu_kin", default: 0, null: false
    t.string "ki", default: "", null: false
    t.string "bumon", default: "", null: false
    t.string "seikyu_m", default: "", null: false
    t.string "tantou", default: "", null: false
    t.string "renban", default: "", null: false
    t.string "edaban", default: "", null: false
    t.string "yobi", default: "", null: false
    t.string "seikyu_key_link", default: "", null: false
  end

  create_table "excel_shiire_lists", force: :cascade do |t|
    t.string "denpyo_kugiri", default: "", null: false
    t.string "hojyo_kamoku", default: "", null: false
    t.string "torihikisaki", default: "", null: false
    t.string "tekiyo1", default: "", null: false
    t.string "tekiyo2", default: "", null: false
    t.string "tekiyo3", default: "", null: false
    t.string "biko", default: "", null: false
    t.integer "kingaku", default: 0, null: false
    t.integer "zei", default: 0, null: false
    t.string "bumon", default: "", null: false
    t.string "kasikata_kamoku", default: "", null: false
    t.integer "syouhizei", default: 0, null: false
    t.integer "gokei_kingaku", default: 0, null: false
    t.string "kaikake_kin", default: "", null: false
    t.string "hizuke", default: "", null: false
    t.string "torihikisaki_c", default: "", null: false
    t.string "seikyu_key_link", default: "", null: false
  end

  create_table "raku_ren_seikyus", force: :cascade do |t|
    t.string "jido_renban", default: "", null: false
    t.integer "dantai_kbn", default: 0, null: false
    t.integer "jichitai_cd", default: 0, null: false
    t.string "todoufuken", default: "", null: false
    t.string "shikutyouson", default: "", null: false
    t.integer "kigyou_cd", default: 0, null: false
    t.string "kigyou", default: "", null: false
    t.string "bunrui", default: "", null: false
    t.string "userkey", default: "", null: false
    t.index ["userkey"], name: "index_raku_ren_seikyus_on_userkey"
  end

  create_table "raku_ren_shisetus", force: :cascade do |t|
    t.string "seikyu_keylink", default: "", null: false
    t.string "bango", default: "", null: false
    t.string "shisetu", default: "", null: false
    t.integer "shisetu_cd", default: 0, null: false
    t.string "userkey", default: "", null: false
    t.index ["shisetu_cd", "userkey"], name: "index_raku_ren_shisetus_on_shisetu_cd_and_userkey"
  end

  create_table "seikyu_tuki_cals", force: :cascade do |t|
    t.string "seikyu_key_link", default: "", null: false
    t.string "yuusyou_kaishi_ym", default: "", null: false
    t.string "yuusyou_syuryo_ym", default: "", null: false
    t.integer "seikyu_m_su", default: 0, null: false
    t.string "siharai_kikan_cd", default: "", null: false
    t.string "print_flg", default: "", null: false
    t.string "seikyu_ym", default: "", null: false
    t.bigint "sisetu_kanribu_teisyutu0_id", null: false
    t.index ["sisetu_kanribu_teisyutu0_id"], name: "index_seikyu_tuki_cals_on_sisetu_kanribu_teisyutu0_id"
  end

  create_table "seikyu_tuki_reigais", force: :cascade do |t|
    t.string "seikyu_key_link", default: "", null: false
    t.string "sisetu_nm", default: "", null: false
    t.integer "seikyu_m_su", default: 0, null: false
    t.string "biko_user", default: "", null: false
    t.string "biko_siyou", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seikyu_yote_cals", force: :cascade do |t|
    t.string "seikyu_ym", default: "", null: false
    t.integer "seikyu_kin", default: 0, null: false
    t.integer "assen_tesuryo", default: 0, null: false
  end

  create_table "sisetu_kanribu_teisyutu0s", force: :cascade do |t|
    t.datetime "update_raku", null: false
    t.string "seikyu_key_link", default: "", null: false
    t.string "bango", default: "", null: false
    t.integer "sisetu_cd", null: false
    t.string "sisetu_nm", default: "", null: false
    t.string "yuusyou_kaishi_ym", default: "", null: false
    t.string "yuusyou_syuryo_ym", default: "", null: false
    t.integer "tanka", default: 0, null: false
    t.integer "assen_tesuryo", default: 0, null: false
    t.integer "seikyu_m_su", default: 0, null: false
    t.string "seikyu_syo_naiyo_ue", default: "", null: false
    t.string "tokuisaki_cd", default: "", null: false
    t.string "seikyu_saki1", default: "", null: false
    t.string "siharai_yotei_kbn", default: "", null: false
    t.string "siharai_ymd_yokust", default: "", null: false
    t.string "siharai_ymd_yokued", default: "", null: false
    t.string "ki", default: "", null: false
    t.string "seikyu_m", default: "", null: false
    t.string "tantou_cd", default: "", null: false
    t.string "shiire_cd", default: "", null: false
    t.string "shiire_nm", default: "", null: false
    t.string "uri_m", default: "", null: false
    t.string "siharai_kikan_cd", default: "", null: false
    t.string "seikyu_basho", default: "", null: false
    t.string "hakko_flg_seikyu_syo", default: "", null: false
    t.string "print_flg", default: "", null: false
    t.string "hasu_kbn_seikyu_gaku", default: "", null: false
    t.string "hasu_kbn_syouhizei", default: "", null: false
    t.string "id_user", default: "", null: false
    t.string "nyukin_out_flg", default: "", null: false
    t.string "todoufuken", default: "", null: false
    t.string "shikutyouson", default: "", null: false
    t.string "kigyou", default: "", null: false
    t.string "seikyu_saki2", default: "", null: false
    t.string "bunrui", default: "", null: false
    t.datetime "created_at"
  end

  create_table "sisetu_kanribu_teisyutu1s", force: :cascade do |t|
    t.datetime "update_raku", null: false
    t.string "seikyu_key_link", default: "", null: false
    t.string "bango", default: "", null: false
    t.integer "sisetu_cd", null: false
    t.string "sisetu_nm", default: "", null: false
    t.string "yuusyou_kaishi_ym", default: "", null: false
    t.string "yuusyou_syuryo_ym", default: "", null: false
    t.integer "tanka", default: 0, null: false
    t.integer "assen_tesuryo", default: 0, null: false
    t.integer "seikyu_m_su", default: 0, null: false
    t.string "seikyu_syo_naiyo_ue", default: "", null: false
    t.string "tokuisaki_cd", default: "", null: false
    t.string "seikyu_saki1", default: "", null: false
    t.string "siharai_yotei_kbn", default: "", null: false
    t.string "siharai_ymd_yokust", default: "", null: false
    t.string "siharai_ymd_yokued", default: "", null: false
    t.string "ki", default: "", null: false
    t.string "seikyu_m", default: "", null: false
    t.string "tantou_cd", default: "", null: false
    t.string "shiire_cd", default: "", null: false
    t.datetime "created_at"
  end

  create_table "sisetu_kanribu_teisyutu2s", force: :cascade do |t|
    t.datetime "update_raku", null: false
    t.string "shiire_nm", default: "", null: false
    t.string "uri_m", default: "", null: false
    t.string "siharai_kikan_cd", default: "", null: false
    t.string "seikyu_basho", default: "", null: false
    t.string "hakko_flg_seikyu_syo", default: "", null: false
    t.string "print_flg", default: "", null: false
    t.string "hasu_kbn_seikyu_gaku", default: "", null: false
    t.string "hasu_kbn_syouhizei", default: "", null: false
    t.string "id_user", default: "", null: false
    t.string "nyukin_out_flg", default: "", null: false
    t.datetime "created_at"
  end

  create_table "sisetu_kanribu_teisyutu3s", force: :cascade do |t|
    t.datetime "update_raku", null: false
    t.string "todoufuken", default: "", null: false
    t.string "shikutyouson", default: "", null: false
    t.string "kigyou", default: "", null: false
    t.string "seikyu_saki2", default: "", null: false
    t.string "bunrui", default: "", null: false
    t.datetime "created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_id", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "seikyu_tuki_cals", "sisetu_kanribu_teisyutu0s"
end
