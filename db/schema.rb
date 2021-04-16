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

ActiveRecord::Schema.define(version: 2021_01_11_192807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"

  create_table "acls", force: :cascade do |t|
    t.bigint "teacher_id"
    t.boolean "enabled", default: true
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_acls_on_teacher_id"
  end

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
    t.index ["segment_id"], name: "index_activity_sequences_on_segment_id"
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

  create_table "advisors", force: :cascade do |t|
    t.string "old_id"
    t.string "name"
  end

  create_table "advisors_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "advisor_id", null: false
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

  create_table "answers", force: :cascade do |t|
    t.string "comment"
    t.integer "rating"
    t.bigint "survey_form_answer_id"
    t.bigint "survey_form_content_block_id"
    t.bigint "teacher_id"
    t.index ["survey_form_answer_id"], name: "index_answers_on_survey_form_answer_id"
    t.index ["survey_form_content_block_id"], name: "index_answers_on_survey_form_content_block_id"
    t.index ["teacher_id"], name: "index_answers_on_teacher_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "old_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "areas_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "area_id", null: false
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

  create_table "axes_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "axis_id", null: false
  end

  create_table "challenge_content_blocks", force: :cascade do |t|
    t.bigint "challenge_id"
    t.bigint "content_block_id"
    t.integer "sequence"
    t.jsonb "content", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_content_blocks_on_challenge_id"
    t.index ["content_block_id"], name: "index_challenge_content_blocks_on_content_block_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "keywords"
    t.date "finish_at"
    t.integer "category"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges_curricular_components", id: false, force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "curricular_component_id", null: false
    t.index ["challenge_id", "curricular_component_id"], name: "index_c_cc_on_c_id_cc_id"
    t.index ["curricular_component_id", "challenge_id"], name: "index_c_lo_on_cc_id_c_id"
  end

  create_table "challenges_knowledge_matrices", id: false, force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "knowledge_matrix_id", null: false
    t.index ["challenge_id", "knowledge_matrix_id"], name: "index_c_km_on_km_c_id"
    t.index ["knowledge_matrix_id", "challenge_id"], name: "index_km_c_on_c_km_id"
  end

  create_table "challenges_learning_objectives", id: false, force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "learning_objective_id", null: false
    t.index ["challenge_id", "learning_objective_id"], name: "index_c_lo_on_c_id_alo_id"
    t.index ["learning_objective_id", "challenge_id"], name: "index_c_lo_on_lo_id_ac_id"
  end

  create_table "challenges_teachers", id: false, force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "teacher_id", null: false
    t.index ["challenge_id", "teacher_id"], name: "index_challenges_teachers_on_challenge_id_and_teacher_id"
    t.index ["teacher_id", "challenge_id"], name: "index_challenges_teachers_on_teacher_id_and_challenge_id"
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

  create_table "collection_projects", force: :cascade do |t|
    t.bigint "collection_id"
    t.bigint "project_id"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_projects_on_collection_id"
    t.index ["project_id"], name: "index_collection_projects_on_project_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.bigint "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_collections_on_teacher_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.bigint "teacher_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_comments_on_project_id"
    t.index ["teacher_id"], name: "index_comments_on_teacher_id"
  end

  create_table "complement_book_links", force: :cascade do |t|
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "complement_book_id"
    t.index ["complement_book_id"], name: "index_complement_book_links_on_complement_book_id"
  end

  create_table "complement_books", force: :cascade do |t|
    t.string "name"
    t.string "author"
    t.string "cover_image"
    t.string "book_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "partner_id"
    t.index ["partner_id"], name: "index_complement_books_on_partner_id"
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

  create_table "curricular_components_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "curricular_component_id", null: false
  end

  create_table "curriculum_subjects", force: :cascade do |t|
    t.string "old_id"
    t.string "name"
  end

  create_table "curriculum_subjects_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "curriculum_subject_id", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "imageable_id"
    t.string "imageable_type"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"
  end

  create_table "knowledge_matrices", force: :cascade do |t|
    t.string "title"
    t.text "know_description"
    t.text "for_description"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "knowledge_matrices_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "knowledge_matrix_id", null: false
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

  create_table "learning_objectives_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "learning_objective_id", null: false
  end

  create_table "learning_objectives_sustainable_development_goals", id: false, force: :cascade do |t|
    t.bigint "sustainable_development_goal_id", null: false
    t.bigint "learning_objective_id", null: false
    t.index ["learning_objective_id", "sustainable_development_goal_id"], name: "index_sdg_lo_on_lo_id_asdg_id"
    t.index ["sustainable_development_goal_id", "learning_objective_id"], name: "index_sdg_lo_on_sdg_id_alo_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "linkable_id"
    t.string "linkable_type"
    t.string "link"
    t.index ["linkable_id"], name: "index_links_on_linkable_id"
    t.index ["linkable_type"], name: "index_links_on_linkable_type"
  end

  create_table "methodologies", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "subtitle"
    t.text "description"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.string "old_id"
    t.string "name"
  end

  create_table "participants_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "participant_id", null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permitted_actions", force: :cascade do |t|
    t.string "class_name"
    t.string "name"
  end

  create_table "permitted_actions_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "permitted_action_id", null: false
  end

  create_table "project_links", force: :cascade do |t|
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.index ["project_id"], name: "index_project_links_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "old_id"
    t.string "title"
    t.string "school_name"
    t.string "dre"
    t.string "description"
    t.string "summary"
    t.string "owners"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "development_year"
    t.string "development_class"
    t.bigint "teacher_id"
    t.bigint "regional_education_board_id"
    t.bigint "school_id"
    t.string "slug"
    t.boolean "updated_by_admin"
    t.index ["regional_education_board_id"], name: "index_projects_on_regional_education_board_id"
    t.index ["school_id"], name: "index_projects_on_school_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["teacher_id"], name: "index_projects_on_teacher_id"
  end

  create_table "projects_segments", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "segment_id", null: false
  end

  create_table "projects_stages", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "stage_id", null: false
  end

  create_table "projects_student_protagonisms", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "student_protagonism_id", null: false
  end

  create_table "projects_sustainable_development_goals", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "sustainable_development_goal_id", null: false
  end

  create_table "projects_tags", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "tag_id", null: false
  end

  create_table "projects_years", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "year_id", null: false
  end

  create_table "public_consultations", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "cover_image"
    t.string "documents", default: [], array: true
    t.datetime "initial_date"
    t.datetime "final_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "segment_id"
    t.index ["segment_id"], name: "index_public_consultations_on_segment_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "sequence"
    t.text "description"
    t.boolean "enable", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regional_education_boards", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.bigint "challenge_id"
    t.bigint "teacher_id"
    t.boolean "enabled", default: true
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "class_name"
    t.index ["challenge_id"], name: "index_results_on_challenge_id"
    t.index ["teacher_id"], name: "index_results_on_teacher_id"
  end

  create_table "roadmaps", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "school_type"
    t.bigint "regional_education_board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["regional_education_board_id"], name: "index_schools_on_regional_education_board_id"
  end

  create_table "segments", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "sequence"
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
    t.integer "sequence"
    t.index ["segment_id"], name: "index_stages_on_segment_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "methodology_id"
    t.string "title"
    t.text "description"
    t.index ["methodology_id"], name: "index_steps_on_methodology_id"
  end

  create_table "student_protagonisms", force: :cascade do |t|
    t.string "description"
    t.integer "sequence"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_form_answers", force: :cascade do |t|
    t.boolean "anonymous"
    t.boolean "finished"
    t.bigint "survey_form_id"
    t.bigint "teacher_id"
    t.index ["survey_form_id"], name: "index_survey_form_answers_on_survey_form_id"
    t.index ["teacher_id"], name: "index_survey_form_answers_on_teacher_id"
  end

  create_table "survey_form_content_blocks", force: :cascade do |t|
    t.bigint "survey_form_id"
    t.bigint "content_block_id"
    t.integer "sequence"
    t.jsonb "content", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_block_id"], name: "index_survey_form_content_blocks_on_content_block_id"
    t.index ["survey_form_id"], name: "index_survey_form_content_blocks_on_survey_form_id"
  end

  create_table "survey_forms", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "sequence"
    t.jsonb "content"
    t.bigint "public_consultation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["public_consultation_id"], name: "index_survey_forms_on_public_consultation_id"
  end

  create_table "sustainable_development_goals", force: :cascade do |t|
    t.integer "sequence"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "tags", force: :cascade do |t|
    t.string "old_id"
    t.string "name"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "nickname"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
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
    t.string "email", default: ""
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
    t.boolean "admin", default: true
    t.string "jti", null: false
    t.string "sme_token"
    t.string "sme_refresh_token"
    t.string "username"
    t.string "name"
    t.string "dre"
    t.boolean "superadmin", default: false, null: false
    t.boolean "blocked", default: false
    t.index ["email"], name: "index_users_on_email"
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
    t.integer "sequence"
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
  add_foreign_key "answer_books", "curricular_components"
  add_foreign_key "answers", "survey_form_answers"
  add_foreign_key "answers", "survey_form_content_blocks"
  add_foreign_key "answers", "teachers"
  add_foreign_key "axes", "curricular_components"
  add_foreign_key "challenge_content_blocks", "challenges"
  add_foreign_key "challenge_content_blocks", "content_blocks"
  add_foreign_key "collection_activity_sequences", "activity_sequences"
  add_foreign_key "collection_activity_sequences", "collections"
  add_foreign_key "collection_projects", "collections"
  add_foreign_key "collection_projects", "projects"
  add_foreign_key "collections", "teachers"
  add_foreign_key "comments", "projects"
  add_foreign_key "comments", "teachers"
  add_foreign_key "complement_book_links", "complement_books"
  add_foreign_key "favourites", "teachers"
  add_foreign_key "goals", "sustainable_development_goals"
  add_foreign_key "layer", "topology", name: "layer_topology_id_fkey"
  add_foreign_key "learning_objectives", "curricular_components"
  add_foreign_key "project_links", "projects"
  add_foreign_key "public_consultations", "segments"
  add_foreign_key "results", "challenges"
  add_foreign_key "results", "teachers"
  add_foreign_key "schools", "regional_education_boards"
  add_foreign_key "stages", "segments"
  add_foreign_key "steps", "methodologies"
  add_foreign_key "survey_form_answers", "survey_forms"
  add_foreign_key "survey_form_answers", "teachers"
  add_foreign_key "survey_form_content_blocks", "content_blocks"
  add_foreign_key "survey_form_content_blocks", "survey_forms"
  add_foreign_key "survey_forms", "public_consultations"
  add_foreign_key "teachers", "users"
  add_foreign_key "years", "segments"
  add_foreign_key "years", "stages"
end
