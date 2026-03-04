# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_03_04_041512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaign_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "campaign_id", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_memberships_on_campaign_id"
    t.index ["user_id", "campaign_id"], name: "index_campaign_memberships_on_user_id_and_campaign_id", unique: true
    t.index ["user_id"], name: "index_campaign_memberships_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name", null: false
    t.string "invite_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_code"], name: "index_campaigns_on_invite_code", unique: true
  end

  create_table "hexes", force: :cascade do |t|
    t.bigint "map_id", null: false
    t.integer "q", null: false
    t.integer "r", null: false
    t.boolean "active", default: false, null: false
    t.string "status", default: "unrevealed", null: false
    t.bigint "terrain_type_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id", "q", "r"], name: "index_hexes_on_map_id_and_q_and_r", unique: true
    t.index ["map_id"], name: "index_hexes_on_map_id"
    t.index ["terrain_type_id"], name: "index_hexes_on_terrain_type_id"
  end

  create_table "maps", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.string "name", null: false
    t.integer "grid_cols", null: false
    t.integer "grid_rows", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "name"], name: "index_maps_on_campaign_id_and_name", unique: true
    t.index ["campaign_id"], name: "index_maps_on_campaign_id"
  end

  create_table "player_notes", force: :cascade do |t|
    t.bigint "hex_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hex_id", "user_id"], name: "index_player_notes_on_hex_id_and_user_id", unique: true
    t.index ["hex_id"], name: "index_player_notes_on_hex_id"
    t.index ["user_id"], name: "index_player_notes_on_user_id"
  end

  create_table "terrain_types", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.string "name", null: false
    t.string "color", null: false
    t.string "icon", null: false
    t.boolean "built_in", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "name"], name: "index_terrain_types_on_campaign_id_and_name", unique: true
    t.index ["campaign_id"], name: "index_terrain_types_on_campaign_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "campaign_memberships", "campaigns"
  add_foreign_key "campaign_memberships", "users"
  add_foreign_key "hexes", "maps", on_delete: :cascade
  add_foreign_key "hexes", "terrain_types", on_delete: :nullify
  add_foreign_key "maps", "campaigns", on_delete: :cascade
  add_foreign_key "player_notes", "hexes", on_delete: :cascade
  add_foreign_key "player_notes", "users"
  add_foreign_key "terrain_types", "campaigns", on_delete: :cascade
end
