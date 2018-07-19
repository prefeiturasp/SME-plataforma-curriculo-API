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

ActiveRecord::Schema.define(version: 2018_07_18_204028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.integer "sequence"
    t.string "title"
    t.integer "estimated_time"
    t.jsonb "content"
    t.bigint "activity_sequence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.integer "environment"
    t.index ["activity_sequence_id"], name: "index_activities_on_activity_sequence_id"
    t.index ["slug"], name: "index_activities_on_slug", unique: true
  end

  create_table "activities_activity_types", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "activity_type_id", null: false
    t.index ["activity_id", "activity_type_id"], name: "idx_act_act_types_on_activity_id_and_activity_type_id"
    t.index ["activity_type_id", "activity_id"], name: "idx_act_act_types_on_activity_type_id_and_activity_id"
  end

  create_table "activities_curricular_components", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "curricular_component_id", null: false
    t.index ["activity_id", "curricular_component_id"], name: "index_activity_component_on_activity_id_and_component_id"
    t.index ["curricular_component_id", "activity_id"], name: "index_activity_component_on_component_id_and_activity_id"
  end

  create_table "activities_learning_objectives", id: false, force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "learning_objective_id", null: false
    t.index ["activity_id", "learning_objective_id"], name: "idx_activity_learning_on_activity_id_and_lo_id"
    t.index ["learning_objective_id", "activity_id"], name: "idx_activity_learning_on_lo_id_and_activity_id"
  end

  create_table "activity_sequences", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.text "presentation_text"
    t.jsonb "books"
    t.integer "estimated_time"
    t.integer "status"
    t.bigint "main_curricular_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.index ["main_curricular_component_id"], name: "index_activity_sequences_on_main_curricular_component_id"
    t.index ["slug"], name: "index_activity_sequences_on_slug", unique: true
  end

  create_table "activity_sequences_axes", id: false, force: :cascade do |t|
    t.bigint "activity_sequence_id", null: false
    t.bigint "axis_id", null: false
  end

  create_table "activity_sequences_knowledge_matrices", id: false, force: :cascade do |t|
    t.bigint "activity_sequence_id", null: false
    t.bigint "knowledge_matrix_id", null: false
    t.index ["activity_sequence_id", "knowledge_matrix_id"], name: "idx_activity_seq_knowledge_on_activity_id_and_knowledge_id"
    t.index ["knowledge_matrix_id", "activity_sequence_id"], name: "idx_activity_seq_knowledge_on_knowledge_id_and_activity_id"
  end

  create_table "activity_sequences_learning_objectives", id: false, force: :cascade do |t|
    t.bigint "activity_sequence_id", null: false
    t.bigint "learning_objective_id", null: false
    t.index ["activity_sequence_id", "learning_objective_id"], name: "idx_activity_seq_learning_on_activity_seq_id_and_lo_id"
    t.index ["learning_objective_id", "activity_sequence_id"], name: "idx_activity_seq_learning_on_lo_id_and_activity_seq_id"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addr", primary_key: "gid", id: :serial, force: :cascade do |t|
    t.bigint "tlid"
    t.string "fromhn", limit: 12
    t.string "tohn", limit: 12
    t.string "side", limit: 1
    t.string "zip", limit: 5
    t.string "plus4", limit: 4
    t.string "fromtyp", limit: 1
    t.string "totyp", limit: 1
    t.integer "fromarmid"
    t.integer "toarmid"
    t.string "arid", limit: 22
    t.string "mtfcc", limit: 5
    t.string "statefp", limit: 2
    t.index ["tlid", "statefp"], name: "idx_tiger_addr_tlid_statefp"
    t.index ["zip"], name: "idx_tiger_addr_zip"
  end

# Could not dump table "addrfeat" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "axes", force: :cascade do |t|
    t.string "description"
    t.bigint "curricular_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curricular_component_id"], name: "index_axes_on_curricular_component_id"
  end

# Could not dump table "bg" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "county" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "county_lookup", primary_key: ["st_code", "co_code"], force: :cascade do |t|
    t.integer "st_code", null: false
    t.string "state", limit: 2
    t.integer "co_code", null: false
    t.string "name", limit: 90
    t.index "soundex((name)::text)", name: "county_lookup_name_idx"
    t.index ["state"], name: "county_lookup_state_idx"
  end

  create_table "countysub_lookup", primary_key: ["st_code", "co_code", "cs_code"], force: :cascade do |t|
    t.integer "st_code", null: false
    t.string "state", limit: 2
    t.integer "co_code", null: false
    t.string "county", limit: 90
    t.integer "cs_code", null: false
    t.string "name", limit: 90
    t.index "soundex((name)::text)", name: "countysub_lookup_name_idx"
    t.index ["state"], name: "countysub_lookup_state_idx"
  end

# Could not dump table "cousub" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "curricular_components", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "color"
    t.index ["slug"], name: "index_curricular_components_on_slug", unique: true
  end

  create_table "direction_lookup", primary_key: "name", id: :string, limit: 20, force: :cascade do |t|
    t.string "abbrev", limit: 3
    t.index ["abbrev"], name: "direction_lookup_abbrev_idx"
  end

# Could not dump table "edges" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "faces" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "featnames", primary_key: "gid", id: :serial, force: :cascade do |t|
    t.bigint "tlid"
    t.string "fullname", limit: 100
    t.string "name", limit: 100
    t.string "predirabrv", limit: 15
    t.string "pretypabrv", limit: 50
    t.string "prequalabr", limit: 15
    t.string "sufdirabrv", limit: 15
    t.string "suftypabrv", limit: 50
    t.string "sufqualabr", limit: 15
    t.string "predir", limit: 2
    t.string "pretyp", limit: 3
    t.string "prequal", limit: 2
    t.string "sufdir", limit: 2
    t.string "suftyp", limit: 3
    t.string "sufqual", limit: 2
    t.string "linearid", limit: 22
    t.string "mtfcc", limit: 5
    t.string "paflag", limit: 1
    t.string "statefp", limit: 2
    t.index "lower((name)::text)", name: "idx_tiger_featnames_lname"
    t.index "soundex((name)::text)", name: "idx_tiger_featnames_snd_name"
    t.index ["tlid", "statefp"], name: "idx_tiger_featnames_tlid_statefp"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "geocode_settings", primary_key: "name", id: :text, force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "geocode_settings_default", primary_key: "name", id: :text, force: :cascade do |t|
    t.text "setting"
    t.text "unit"
    t.text "category"
    t.text "short_desc"
  end

  create_table "goals", force: :cascade do |t|
    t.text "description"
    t.bigint "sustainable_development_goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sustainable_development_goal_id"], name: "index_goals_on_sustainable_development_goal_id"
  end

  create_table "knowledge_matrices", force: :cascade do |t|
    t.string "title"
    t.text "know_description"
    t.text "for_description"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "learning_objectives", force: :cascade do |t|
    t.integer "year"
    t.string "code"
    t.string "description"
    t.bigint "curricular_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curricular_component_id"], name: "index_learning_objectives_on_curricular_component_id"
  end

  create_table "learning_objectives_sustainable_development_goals", id: false, force: :cascade do |t|
    t.bigint "sustainable_development_goal_id", null: false
    t.bigint "learning_objective_id", null: false
    t.index ["learning_objective_id", "sustainable_development_goal_id"], name: "index_sdg_lo_on_lo_id_asdg_id"
    t.index ["sustainable_development_goal_id", "learning_objective_id"], name: "index_sdg_lo_on_sdg_id_alo_id"
  end

  create_table "loader_lookuptables", primary_key: "lookup_name", id: :text, comment: "This is the table name to inherit from and suffix of resulting output table -- how the table will be named --  edges here would mean -- ma_edges , pa_edges etc. except in the case of national tables. national level tables have no prefix", force: :cascade do |t|
    t.integer "process_order", default: 1000, null: false
    t.text "table_name", comment: "suffix of the tables to load e.g.  edges would load all tables like *edges.dbf(shp)  -- so tl_2010_42129_edges.dbf .  "
    t.boolean "single_mode", default: true, null: false
    t.boolean "load", default: true, null: false, comment: "Whether or not to load the table.  For states and zcta5 (you may just want to download states10, zcta510 nationwide file manually) load your own into a single table that inherits from tiger.states, tiger.zcta5.  You'll get improved performance for some geocoding cases."
    t.boolean "level_county", default: false, null: false
    t.boolean "level_state", default: false, null: false
    t.boolean "level_nation", default: false, null: false, comment: "These are tables that contain all data for the whole US so there is just a single file"
    t.text "post_load_process"
    t.boolean "single_geom_mode", default: false
    t.string "insert_mode", limit: 1, default: "c", null: false
    t.text "pre_load_process"
    t.text "columns_exclude", comment: "List of columns to exclude as an array. This is excluded from both input table and output table and rest of columns remaining are assumed to be in same order in both tables. gid, geoid,cpi,suffix1ce are excluded if no columns are specified.", array: true
    t.text "website_root_override", comment: "Path to use for wget instead of that specified in year table.  Needed currently for zcta where they release that only for 2000 and 2010"
  end

  create_table "loader_platform", primary_key: "os", id: :string, limit: 50, force: :cascade do |t|
    t.text "declare_sect"
    t.text "pgbin"
    t.text "wget"
    t.text "unzip_command"
    t.text "psql"
    t.text "path_sep"
    t.text "loader"
    t.text "environ_set_command"
    t.text "county_process_command"
  end

  create_table "loader_variables", primary_key: "tiger_year", id: :string, limit: 4, force: :cascade do |t|
    t.text "website_root"
    t.text "staging_fold"
    t.text "data_schema"
    t.text "staging_schema"
  end

  create_table "pagc_gaz", id: :serial, force: :cascade do |t|
    t.integer "seq"
    t.text "word"
    t.text "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_lex", id: :serial, force: :cascade do |t|
    t.integer "seq"
    t.text "word"
    t.text "stdword"
    t.integer "token"
    t.boolean "is_custom", default: true, null: false
  end

  create_table "pagc_rules", id: :serial, force: :cascade do |t|
    t.text "rule"
    t.boolean "is_custom", default: true
  end

# Could not dump table "place" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "place_lookup", primary_key: ["st_code", "pl_code"], force: :cascade do |t|
    t.integer "st_code", null: false
    t.string "state", limit: 2
    t.integer "pl_code", null: false
    t.string "name", limit: 90
    t.index "soundex((name)::text)", name: "place_lookup_name_idx"
    t.index ["state"], name: "place_lookup_state_idx"
  end

  create_table "roadmaps", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "secondary_unit_lookup", primary_key: "name", id: :string, limit: 20, force: :cascade do |t|
    t.string "abbrev", limit: 5
    t.index ["abbrev"], name: "secondary_unit_lookup_abbrev_idx"
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, default: nil, force: :cascade do |t|
    t.string "auth_name", limit: 256
    t.integer "auth_srid"
    t.string "srtext", limit: 2048
    t.string "proj4text", limit: 2048
  end

# Could not dump table "state" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "state_lookup", primary_key: "st_code", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 40
    t.string "abbrev", limit: 3
    t.string "statefp", limit: 2
    t.index ["abbrev"], name: "state_lookup_abbrev_key", unique: true
    t.index ["name"], name: "state_lookup_name_key", unique: true
    t.index ["statefp"], name: "state_lookup_statefp_key", unique: true
  end

  create_table "street_type_lookup", primary_key: "name", id: :string, limit: 50, force: :cascade do |t|
    t.string "abbrev", limit: 50
    t.boolean "is_hw", default: false, null: false
    t.index ["abbrev"], name: "street_type_lookup_abbrev_idx"
  end

  create_table "sustainable_development_goals", force: :cascade do |t|
    t.integer "sequence"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

# Could not dump table "tabblock" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

# Could not dump table "tract" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

# Could not dump table "zcta5" because of following StandardError
#   Unknown type 'geometry' for column 'the_geom'

  create_table "zip_lookup", primary_key: "zip", id: :integer, default: nil, force: :cascade do |t|
    t.integer "st_code"
    t.string "state", limit: 2
    t.integer "co_code"
    t.string "county", limit: 90
    t.integer "cs_code"
    t.string "cousub", limit: 90
    t.integer "pl_code"
    t.string "place", limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_all", id: false, force: :cascade do |t|
    t.integer "zip"
    t.integer "st_code"
    t.string "state", limit: 2
    t.integer "co_code"
    t.string "county", limit: 90
    t.integer "cs_code"
    t.string "cousub", limit: 90
    t.integer "pl_code"
    t.string "place", limit: 90
    t.integer "cnt"
  end

  create_table "zip_lookup_base", primary_key: "zip", id: :string, limit: 5, force: :cascade do |t|
    t.string "state", limit: 40
    t.string "county", limit: 90
    t.string "city", limit: 90
    t.string "statefp", limit: 2
  end

  create_table "zip_state", primary_key: ["zip", "stusps"], force: :cascade do |t|
    t.string "zip", limit: 5, null: false
    t.string "stusps", limit: 2, null: false
    t.string "statefp", limit: 2
  end

  create_table "zip_state_loc", primary_key: ["zip", "stusps", "place"], force: :cascade do |t|
    t.string "zip", limit: 5, null: false
    t.string "stusps", limit: 2, null: false
    t.string "statefp", limit: 2
    t.string "place", limit: 100, null: false
  end

  add_foreign_key "activities", "activity_sequences"
  add_foreign_key "activity_sequences", "curricular_components", column: "main_curricular_component_id"
  add_foreign_key "axes", "curricular_components"
  add_foreign_key "goals", "sustainable_development_goals"
  add_foreign_key "learning_objectives", "curricular_components"
end
