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

ActiveRecord::Schema.define(version: 2020_05_30_105649) do

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
    t.integer "status", default: 0
    t.index ["activity_sequence_id"], name: "index_activities_on_activity_sequence_id"
    t.index ["slug"], name: "index_activities_on_slug", unique: true
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

  create_table "activity_content_blocks", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "content_block_id"
    t.integer "sequence"
    t.jsonb "content", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_content_blocks_on_activity_id"
    t.index ["content_block_id"], name: "index_activity_content_blocks_on_content_block_id"
  end

  create_table "activity_sequence_performeds", force: :cascade do |t|
    t.bigint "activity_sequence_id"
    t.bigint "teacher_id"
    t.boolean "evaluated", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_sequence_id"], name: "index_activity_sequence_performeds_on_activity_sequence_id"
    t.index ["teacher_id"], name: "index_activity_sequence_performeds_on_teacher_id"
  end

  create_table "activity_sequence_ratings", force: :cascade do |t|
    t.bigint "activity_sequence_performed_id"
    t.bigint "rating_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_sequence_performed_id"], name: "index_activity_seq_ratings_on_activity_seq_performed_id"
    t.index ["rating_id"], name: "index_activity_sequence_ratings_on_rating_id"
  end

  create_table "activity_sequences", force: :cascade do |t|
    t.string "title"
    t.text "presentation_text"
    t.jsonb "books"
    t.integer "estimated_time"
    t.integer "status"
    t.bigint "main_curricular_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "keywords"
    t.bigint "stage_id"
    t.bigint "segment_id"
    t.bigint "year_id"
    t.index ["main_curricular_component_id"], name: "index_activity_sequences_on_main_curricular_component_id"
    t.index ["slug"], name: "index_activity_sequences_on_slug", unique: true
    t.index ["stage_id"], name: "index_activity_sequences_on_stage_id"
    t.index ["year_id"], name: "index_activity_sequences_on_year_id"
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

  create_table "answer_books", force: :cascade do |t|
    t.string "name"
    t.string "cover_image"
    t.string "book_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "curricular_component_id"
    t.bigint "stage_id"
    t.bigint "segment_id"
    t.bigint "year_id"
    t.index ["curricular_component_id"], name: "index_answer_books_on_curricular_component_id"
    t.index ["segment_id"], name: "index_answer_books_on_segment_id"
    t.index ["stage_id"], name: "index_answer_books_on_stage_id"
    t.index ["year_id"], name: "index_answer_books_on_year_id"
  end

  create_table "axes", force: :cascade do |t|
    t.string "description"
    t.bigint "curricular_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curricular_component_id"], name: "index_axes_on_curricular_component_id"
  end

  create_table "axes_learning_objectives", id: false, force: :cascade do |t|
    t.bigint "learning_objective_id", null: false
    t.bigint "axis_id", null: false
  end

  create_table "collection_activity_sequences", force: :cascade do |t|
    t.bigint "collection_id"
    t.bigint "activity_sequence_id"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_sequence_id"], name: "index_collection_activity_sequences_on_activity_sequence_id"
    t.index ["collection_id"], name: "index_collection_activity_sequences_on_collection_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.bigint "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_collections_on_teacher_id"
  end

  create_table "content_blocks", force: :cascade do |t|
    t.integer "content_type"
    t.jsonb "json_schema", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "curricular_components", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "color"
    t.index ["slug"], name: "index_curricular_components_on_slug", unique: true
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "favouritable_id"
    t.string "favouritable_type"
    t.bigint "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favouritable_id"], name: "index_favourites_on_favouritable_id"
    t.index ["favouritable_type"], name: "index_favourites_on_favouritable_type"
    t.index ["teacher_id", "favouritable_id", "favouritable_type"], name: "favourites_unique_index", unique: true
    t.index ["teacher_id"], name: "index_favourites_on_teacher_id"
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

  create_table "goals", force: :cascade do |t|
    t.text "description"
    t.bigint "sustainable_development_goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sustainable_development_goal_id"], name: "index_goals_on_sustainable_development_goal_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "subtitle"
    t.bigint "activity_content_block_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_content_block_id"], name: "index_images_on_activity_content_block_id"
  end

  create_table "knowledge_matrices", force: :cascade do |t|
    t.string "title"
    t.text "know_description"
    t.text "for_description"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "layer", primary_key: ["topology_id", "layer_id"], force: :cascade do |t|
    t.integer "topology_id", null: false
    t.integer "layer_id", null: false
    t.string "schema_name", null: false
    t.string "table_name", null: false
    t.string "feature_column", null: false
    t.integer "feature_type", null: false
    t.integer "level", default: 0, null: false
    t.integer "child_id"
    t.index ["schema_name", "table_name", "feature_column"], name: "layer_schema_name_table_name_feature_column_key", unique: true
  end

  create_table "learning_objectives", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.bigint "curricular_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stage_id"
    t.bigint "segment_id"
    t.bigint "year_id"
    t.index ["curricular_component_id"], name: "index_learning_objectives_on_curricular_component_id"
    t.index ["segment_id"], name: "index_learning_objectives_on_segment_id"
    t.index ["stage_id"], name: "index_learning_objectives_on_stage_id"
    t.index ["year_id"], name: "index_learning_objectives_on_year_id"
  end

  create_table "learning_objectives_sustainable_development_goals", id: false, force: :cascade do |t|
    t.bigint "sustainable_development_goal_id", null: false
    t.bigint "learning_objective_id", null: false
    t.index ["learning_objective_id", "sustainable_development_goal_id"], name: "index_sdg_lo_on_lo_id_asdg_id"
    t.index ["sustainable_development_goal_id", "learning_objective_id"], name: "index_sdg_lo_on_sdg_id_alo_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "sequence"
    t.text "description"
    t.boolean "enable", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roadmaps", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, default: nil, force: :cascade do |t|
    t.string "auth_name", limit: 256
    t.integer "auth_srid"
    t.string "srtext", limit: 2048
    t.string "proj4text", limit: 2048
  end

  create_table "stages", force: :cascade do |t|
    t.string "name"
    t.bigint "segment_id"
    t.index ["segment_id"], name: "index_stages_on_segment_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "methodology_id"
    t.string "title"
    t.text "description"
    t.index ["methodology_id"], name: "index_steps_on_methodology_id"
  end

  create_table "sustainable_development_goals", force: :cascade do |t|
    t.integer "sequence"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "nickname"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "topology", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "srid", null: false
    t.float "precision", null: false
    t.boolean "hasz", default: false, null: false
    t.index ["name"], name: "topology_name_key", unique: true
  end

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
    t.boolean "admin", default: false
    t.string "jti", null: false
    t.string "sme_token"
    t.string "sme_refresh_token"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sme_refresh_token"], name: "index_users_on_sme_refresh_token"
    t.index ["sme_token"], name: "index_users_on_sme_token"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "years", force: :cascade do |t|
    t.string "name"
    t.bigint "segment_id"
    t.bigint "stage_id"
    t.index ["segment_id"], name: "index_years_on_segment_id"
    t.index ["stage_id"], name: "index_years_on_stage_id"
  end

  add_foreign_key "acls", "teachers"
  add_foreign_key "activities", "activity_sequences"
  add_foreign_key "activity_content_blocks", "activities"
  add_foreign_key "activity_content_blocks", "content_blocks"
  add_foreign_key "activity_sequence_performeds", "activity_sequences"
  add_foreign_key "activity_sequence_performeds", "teachers"
  add_foreign_key "activity_sequence_ratings", "activity_sequence_performeds"
  add_foreign_key "activity_sequence_ratings", "ratings"
  add_foreign_key "activity_sequences", "curricular_components", column: "main_curricular_component_id"
  add_foreign_key "axes", "curricular_components"
  add_foreign_key "collection_activity_sequences", "activity_sequences"
  add_foreign_key "collection_activity_sequences", "collections"
  add_foreign_key "collections", "teachers"
  add_foreign_key "favourites", "teachers"
  add_foreign_key "goals", "sustainable_development_goals"
  add_foreign_key "images", "activity_content_blocks"
  add_foreign_key "layer", "topology", name: "layer_topology_id_fkey"
  add_foreign_key "learning_objectives", "curricular_components"
  add_foreign_key "teachers", "users"
  add_foreign_key "years", "segments"
  add_foreign_key "years", "stages"
end
