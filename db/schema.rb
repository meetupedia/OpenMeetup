# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(version: 20120618082322) do

  create_table "absences", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "user_id"
  end

  add_index "absences", ["event_id"], name: "index_absences_on_event_id"
  add_index "absences", ["user_id"], name: "index_absences_on_user_id"

  create_table "activities", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activable_type"
    t.integer  "activable_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "event_id"
  end

  add_index "activities", ["activable_id", "activable_type"], name: "index_activities_on_activable_id_and_activable_type"
  add_index "activities", ["event_id"], name: "index_activities_on_event_id"
  add_index "activities", ["group_id"], name: "index_activities_on_group_id"
  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "answers", force: true do |t|
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "participation_id"
  end

  add_index "answers", ["participation_id"], name: "index_answers_on_participation_id"
  add_index "answers", ["question_id"], name: "index_answers_on_question_id"
  add_index "answers", ["user_id"], name: "index_answers_on_user_id"

  create_table "authentications", force: true do |t|
    t.string  "uid"
    t.string  "provider"
    t.integer "user_id"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id"

  create_table "cities", force: true do |t|
    t.string  "name"
    t.string  "permalink"
    t.integer "country_id"
    t.string  "state"
  end

  add_index "cities", ["country_id"], name: "index_cities_on_country_id"
  add_index "cities", ["name"], name: "index_cities_on_name"
  add_index "cities", ["permalink"], name: "index_cities_on_permalink"

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.boolean  "is_highlighted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_to_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.integer  "user_id"
    t.integer  "level",            default: 0
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["reply_to_id"], name: "index_comments_on_reply_to_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "countries", force: true do |t|
    t.string "name"
    t.string "permalink"
    t.string "code"
  end

  add_index "countries", ["code"], name: "index_countries_on_code"
  add_index "countries", ["name"], name: "index_countries_on_name"
  add_index "countries", ["permalink"], name: "index_countries_on_permalink"

  create_table "event_invitation_targets", force: true do |t|
    t.string   "email"
    t.boolean  "is_accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "event_invitation_id"
    t.integer  "invited_user_id"
  end

  add_index "event_invitation_targets", ["event_id"], name: "index_event_invitation_targets_on_event_id"
  add_index "event_invitation_targets", ["event_invitation_id"], name: "index_event_invitation_targets_on_event_invitation_id"
  add_index "event_invitation_targets", ["invited_user_id"], name: "index_event_invitation_targets_on_invited_user_id"

  create_table "event_invitations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "message"
    t.integer  "invited_user_id"
    t.boolean  "is_accepted"
    t.string   "email"
    t.string   "code"
  end

  add_index "event_invitations", ["event_id"], name: "index_event_invitations_on_event_id"
  add_index "event_invitations", ["invited_user_id"], name: "index_event_invitations_on_invited_user_id"
  add_index "event_invitations", ["user_id"], name: "index_event_invitations_on_user_id"

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "city"
    t.float    "latitude"
    t.string   "country"
    t.string   "street"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "permalink"
    t.string   "place"
    t.integer  "comments_count"
    t.integer  "city_id"
    t.string   "permaname"
  end

  add_index "events", ["city"], name: "index_events_on_city"
  add_index "events", ["city_id"], name: "index_events_on_city_id"
  add_index "events", ["group_id"], name: "index_events_on_group_id"
  add_index "events", ["permalink"], name: "index_events_on_permalink"
  add_index "events", ["permaname"], name: "index_events_on_permaname"
  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "follows", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "group_id"
  end

  add_index "follows", ["group_id"], name: "index_follows_on_group_id"
  add_index "follows", ["user_id"], name: "index_follows_on_user_id"

  create_table "group_invitation_targets", force: true do |t|
    t.string   "email"
    t.boolean  "is_accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_invitation_id"
    t.integer  "group_id"
    t.integer  "invited_user_id"
  end

  add_index "group_invitation_targets", ["group_id"], name: "index_group_invitation_targets_on_group_id"
  add_index "group_invitation_targets", ["group_invitation_id"], name: "index_group_invitation_targets_on_group_invitation_id"
  add_index "group_invitation_targets", ["invited_user_id"], name: "index_group_invitation_targets_on_invited_user_id"

  create_table "group_invitations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "message"
    t.integer  "invited_user_id"
    t.boolean  "is_accepted"
    t.string   "email"
    t.string   "code"
  end

  add_index "group_invitations", ["group_id"], name: "index_group_invitations_on_group_id"
  add_index "group_invitations", ["invited_user_id"], name: "index_group_invitations_on_invited_user_id"
  add_index "group_invitations", ["user_id"], name: "index_group_invitations_on_user_id"

  create_table "group_taggings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "group_taggings", ["group_id"], name: "index_group_taggings_on_group_id"
  add_index "group_taggings", ["tag_id"], name: "index_group_taggings_on_tag_id"
  add_index "group_taggings", ["user_id"], name: "index_group_taggings_on_user_id"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "permalink"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.boolean  "is_closed",           default: false
    t.datetime "image_updated_at"
    t.string   "facebook_url"
    t.string   "url"
    t.string   "facebook_uid"
    t.integer  "language_id"
    t.integer  "city_id"
    t.datetime "header_updated_at"
    t.integer  "header_file_size"
    t.string   "header_content_type"
    t.string   "header_file_name"
    t.integer  "memberships_count",   default: 0
    t.string   "permaname"
  end

  add_index "groups", ["city_id"], name: "index_groups_on_city_id"
  add_index "groups", ["language_id"], name: "index_groups_on_language_id"
  add_index "groups", ["location"], name: "index_groups_on_location"
  add_index "groups", ["permalink"], name: "index_groups_on_permalink"
  add_index "groups", ["permaname"], name: "index_groups_on_permaname"
  add_index "groups", ["user_id"], name: "index_groups_on_user_id"

  create_table "images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.boolean  "is_live",            default: false
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"
  add_index "images", ["user_id"], name: "index_images_on_user_id"

  create_table "interest_taggings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interest_id"
    t.integer  "user_id"
  end

  add_index "interest_taggings", ["interest_id"], name: "index_interest_taggings_on_interest_id"
  add_index "interest_taggings", ["user_id"], name: "index_interest_taggings_on_user_id"

  create_table "interests", force: true do |t|
    t.string   "name"
    t.string   "permalink"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invited_interest_taggings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invited_user_id"
    t.integer  "interest_id"
  end

  add_index "invited_interest_taggings", ["interest_id"], name: "index_invited_interest_taggings_on_interest_id"
  add_index "invited_interest_taggings", ["invited_user_id"], name: "index_invited_interest_taggings_on_invited_user_id"

  create_table "invited_users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "code"
    t.string   "permalink"
    t.string   "locale"
    t.string   "location"
    t.boolean  "i_am_an_organizer"
    t.boolean  "i_am_a_participant"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string "code"
    t.string "name"
  end

  create_table "letter_templates", force: true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "letter_templates", ["user_id"], name: "index_letter_templates_on_user_id"

  create_table "letters", force: true do |t|
    t.string   "subject"
    t.text     "template"
    t.boolean  "is_mailed",   default: false
    t.datetime "mailed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "testuser_id"
  end

  add_index "letters", ["testuser_id"], name: "index_letters_on_testuser_id"
  add_index "letters", ["user_id"], name: "index_letters_on_user_id"

  create_table "membership_requests", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "membership_requests", ["group_id"], name: "index_membership_requests_on_group_id"
  add_index "membership_requests", ["user_id"], name: "index_membership_requests_on_user_id"

  create_table "memberships", force: true do |t|
    t.boolean  "is_admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "notifications", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_id"
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "notifications", ["activity_id"], name: "index_notifications_on_activity_id"
  add_index "notifications", ["group_id"], name: "index_notifications_on_group_id"
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "organizations", force: true do |t|
    t.string "name"
    t.string "permalink"
    t.string "layout_name"
    t.text   "layout"
    t.text   "stylesheets"
  end

  create_table "participations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "user_id"
    t.boolean  "is_checkined", default: false
  end

  add_index "participations", ["event_id"], name: "index_participations_on_event_id"
  add_index "participations", ["user_id"], name: "index_participations_on_user_id"

  create_table "posts", force: true do |t|
    t.integer  "comments_count"
    t.text     "post"
    t.boolean  "is_highlighted", default: false
    t.boolean  "is_broadcasted", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postable_type"
    t.integer  "postable_id"
    t.integer  "user_id"
    t.boolean  "is_live",        default: false
    t.integer  "event_id"
  end

  add_index "posts", ["event_id"], name: "index_posts_on_event_id"
  add_index "posts", ["postable_id", "postable_type"], name: "index_posts_on_postable_id_and_postable_type"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "questions", force: true do |t|
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "user_id"
  end

  add_index "questions", ["event_id"], name: "index_questions_on_event_id"
  add_index "questions", ["user_id"], name: "index_questions_on_user_id"

  create_table "reviews", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "review"
    t.integer  "group_id"
    t.integer  "event_id"
  end

  add_index "reviews", ["event_id"], name: "index_reviews_on_event_id"
  add_index "reviews", ["group_id"], name: "index_reviews_on_group_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "taggings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
    t.integer  "user_id"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["user_id"], name: "index_taggings_on_user_id"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "tags", ["user_id"], name: "index_tags_on_user_id"

  create_table "tr8n_glossary", force: true do |t|
    t.string   "keyword"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tr8n_glossary", ["keyword"], name: "index_tr8n_glossary_on_keyword"

  create_table "tr8n_ip_locations", force: true do |t|
    t.integer  "low",        limit: 8
    t.integer  "high",       limit: 8
    t.string   "registry",   limit: 20
    t.date     "assigned"
    t.string   "ctry",       limit: 2
    t.string   "cntry",      limit: 3
    t.string   "country",    limit: 80
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "tr8n_ip_locations", ["high"], name: "tr8n_il_h"
  add_index "tr8n_ip_locations", ["low"], name: "tr8n_il_l"

  create_table "tr8n_language_case_rules", force: true do |t|
    t.integer  "language_case_id", null: false
    t.integer  "language_id"
    t.integer  "translator_id"
    t.text     "definition",       null: false
    t.integer  "position"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "tr8n_language_case_rules", ["language_case_id"], name: "tr8n_lcr_lc"
  add_index "tr8n_language_case_rules", ["language_id"], name: "tr8n_lcr_l"
  add_index "tr8n_language_case_rules", ["translator_id"], name: "tr8n_lcr_t"

  create_table "tr8n_language_case_value_maps", force: true do |t|
    t.string   "keyword",       null: false
    t.integer  "language_id",   null: false
    t.integer  "translator_id"
    t.text     "map"
    t.boolean  "reported"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tr8n_language_case_value_maps", ["keyword", "language_id"], name: "tr8n_lcvm_kl"
  add_index "tr8n_language_case_value_maps", ["translator_id"], name: "tr8n_lcvm_t"

  create_table "tr8n_language_cases", force: true do |t|
    t.integer  "language_id",   null: false
    t.integer  "translator_id"
    t.string   "keyword"
    t.string   "latin_name"
    t.string   "native_name"
    t.text     "description"
    t.string   "application"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tr8n_language_cases", ["language_id", "keyword"], name: "tr8n_lc_lk"
  add_index "tr8n_language_cases", ["language_id", "translator_id"], name: "tr8n_lc_lt"
  add_index "tr8n_language_cases", ["language_id"], name: "tr8n_lc_l"

  create_table "tr8n_language_forum_abuse_reports", force: true do |t|
    t.integer  "language_id",               null: false
    t.integer  "translator_id",             null: false
    t.integer  "language_forum_message_id", null: false
    t.string   "reason"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "tr8n_language_forum_abuse_reports", ["language_forum_message_id"], name: "tr8n_lfar_lfm"
  add_index "tr8n_language_forum_abuse_reports", ["language_id", "translator_id"], name: "tr8n_lfar_lt"
  add_index "tr8n_language_forum_abuse_reports", ["language_id"], name: "tr8n_lfar_l"

  create_table "tr8n_language_forum_messages", force: true do |t|
    t.integer  "language_id",             null: false
    t.integer  "language_forum_topic_id", null: false
    t.integer  "translator_id",           null: false
    t.text     "message",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "tr8n_language_forum_messages", ["language_id", "language_forum_topic_id"], name: "tr8n_lfm_ll"
  add_index "tr8n_language_forum_messages", ["language_id"], name: "tr8n_lfm_l"
  add_index "tr8n_language_forum_messages", ["translator_id"], name: "tr8n_lfm_t"

  create_table "tr8n_language_forum_topics", force: true do |t|
    t.integer  "translator_id", null: false
    t.integer  "language_id"
    t.text     "topic",         null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tr8n_language_forum_topics", ["language_id"], name: "tr8n_lft_l"
  add_index "tr8n_language_forum_topics", ["translator_id"], name: "tr8n_lft_t"

  create_table "tr8n_language_metrics", force: true do |t|
    t.string   "type"
    t.integer  "language_id",                         null: false
    t.date     "metric_date"
    t.integer  "user_count",           default: 0
    t.integer  "translator_count",     default: 0
    t.integer  "translation_count",    default: 0
    t.integer  "key_count",            default: 0
    t.integer  "locked_key_count",     default: 0
    t.integer  "translated_key_count", default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "tr8n_language_metrics", ["created_at"], name: "tr8n_lm_c"
  add_index "tr8n_language_metrics", ["language_id"], name: "tr8n_lm_l"

  create_table "tr8n_language_rules", force: true do |t|
    t.integer  "language_id",   null: false
    t.integer  "translator_id"
    t.string   "type"
    t.text     "definition"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tr8n_language_rules", ["language_id", "translator_id"], name: "tr8n_lr_lt"
  add_index "tr8n_language_rules", ["language_id"], name: "tr8n_lr_l"

  create_table "tr8n_language_users", force: true do |t|
    t.integer  "language_id",                      null: false
    t.integer  "user_id",                          null: false
    t.integer  "translator_id"
    t.boolean  "manager",       default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "tr8n_language_users", ["created_at"], name: "tr8n_lu_ca"
  add_index "tr8n_language_users", ["language_id", "translator_id"], name: "tr8n_lu_lt"
  add_index "tr8n_language_users", ["language_id", "user_id"], name: "tr8n_lu_lu"
  add_index "tr8n_language_users", ["updated_at"], name: "tr8n_lu_ua"
  add_index "tr8n_language_users", ["user_id"], name: "tr8n_lu_u"

  create_table "tr8n_languages", force: true do |t|
    t.string   "locale",                              null: false
    t.string   "english_name",                        null: false
    t.string   "native_name"
    t.boolean  "enabled"
    t.boolean  "right_to_left"
    t.integer  "completeness"
    t.integer  "fallback_language_id"
    t.text     "curse_words"
    t.integer  "featured_index",       default: 0
    t.string   "google_key"
    t.string   "facebook_key"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "tr8n_languages", ["locale"], name: "tr8n_ll"

  create_table "tr8n_sync_logs", force: true do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "keys_sent"
    t.integer  "translations_sent"
    t.integer  "keys_received"
    t.integer  "translations_received"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tr8n_translation_domains", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "source_count", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "tr8n_translation_domains", ["name"], name: "tr8n_td_n", unique: true

  create_table "tr8n_translation_key_comments", force: true do |t|
    t.integer  "language_id",        null: false
    t.integer  "translation_key_id", null: false
    t.integer  "translator_id",      null: false
    t.text     "message",            null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "tr8n_translation_key_comments", ["language_id", "translation_key_id"], name: "tr8n_tkc_lt"
  add_index "tr8n_translation_key_comments", ["language_id"], name: "tr8n_tkc_l"
  add_index "tr8n_translation_key_comments", ["translator_id"], name: "tr8n_tkc_t"

  create_table "tr8n_translation_key_locks", force: true do |t|
    t.integer  "translation_key_id",                    null: false
    t.integer  "language_id",                           null: false
    t.integer  "translator_id"
    t.boolean  "locked",             default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "tr8n_translation_key_locks", ["translation_key_id", "language_id"], name: "tr8n_tkl_tl"

  create_table "tr8n_translation_key_sources", force: true do |t|
    t.integer  "translation_key_id",    null: false
    t.integer  "translation_source_id", null: false
    t.text     "details"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tr8n_translation_key_sources", ["translation_key_id"], name: "tr8n_tks_tk"
  add_index "tr8n_translation_key_sources", ["translation_source_id"], name: "tr8n_tks_ts"

  create_table "tr8n_translation_keys", force: true do |t|
    t.string   "type"
    t.string   "key",                              null: false
    t.text     "label",                            null: false
    t.text     "description"
    t.datetime "verified_at"
    t.integer  "translation_count"
    t.boolean  "admin"
    t.string   "locale"
    t.integer  "level",             default: 0
    t.datetime "synced_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "tr8n_translation_keys", ["key"], name: "tr8n_tk_k", unique: true

  create_table "tr8n_translation_source_languages", force: true do |t|
    t.integer  "language_id"
    t.integer  "translation_source_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tr8n_translation_source_languages", ["language_id", "translation_source_id"], name: "tr8n_tsl_lt"

  create_table "tr8n_translation_sources", force: true do |t|
    t.string   "source"
    t.integer  "translation_domain_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "tr8n_translation_sources", ["source"], name: "tr8n_ts_s"

  create_table "tr8n_translation_votes", force: true do |t|
    t.integer  "translation_id", null: false
    t.integer  "translator_id",  null: false
    t.integer  "vote",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tr8n_translation_votes", ["translation_id", "translator_id"], name: "tr8n_tv_tt"
  add_index "tr8n_translation_votes", ["translator_id"], name: "tr8n_tv_t"

  create_table "tr8n_translations", force: true do |t|
    t.integer  "translation_key_id",                             null: false
    t.integer  "language_id",                                    null: false
    t.integer  "translator_id",                                  null: false
    t.text     "label",                                          null: false
    t.integer  "rank",                            default: 0
    t.integer  "approved_by_id",     limit: 8
    t.text     "rules"
    t.datetime "synced_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "tr8n_translations", ["created_at"], name: "tr8n_trn_c"
  add_index "tr8n_translations", ["translation_key_id", "translator_id", "language_id"], name: "tr8n_trn_tktl"
  add_index "tr8n_translations", ["translator_id"], name: "tr8n_trn_t"

  create_table "tr8n_translator_following", force: true do |t|
    t.integer  "translator_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tr8n_translator_following", ["translator_id"], name: "tr8n_tf_t"

  create_table "tr8n_translator_logs", force: true do |t|
    t.integer  "translator_id"
    t.integer  "user_id",       limit: 8
    t.string   "action"
    t.integer  "action_level"
    t.string   "reason"
    t.string   "reference"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "tr8n_translator_logs", ["created_at"], name: "tr8n_tl_c"
  add_index "tr8n_translator_logs", ["translator_id"], name: "tr8n_tl_t"
  add_index "tr8n_translator_logs", ["user_id"], name: "tr8n_tl_u"

  create_table "tr8n_translator_metrics", force: true do |t|
    t.integer  "translator_id",                        null: false
    t.integer  "language_id"
    t.integer  "total_translations",    default: 0
    t.integer  "total_votes",           default: 0
    t.integer  "positive_votes",        default: 0
    t.integer  "negative_votes",        default: 0
    t.integer  "accepted_translations", default: 0
    t.integer  "rejected_translations", default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "tr8n_translator_metrics", ["created_at"], name: "tr8n_tm_c"
  add_index "tr8n_translator_metrics", ["translator_id", "language_id"], name: "tr8n_tm_tl"
  add_index "tr8n_translator_metrics", ["translator_id"], name: "tr8n_tm_t"

  create_table "tr8n_translator_reports", force: true do |t|
    t.integer  "translator_id"
    t.string   "state"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "reason"
    t.text     "comment"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tr8n_translator_reports", ["translator_id"], name: "tr8n_tr_t"

  create_table "tr8n_translators", force: true do |t|
    t.integer  "user_id"
    t.boolean  "inline_mode",          default: false
    t.boolean  "blocked",              default: false
    t.boolean  "reported",             default: false
    t.integer  "fallback_language_id"
    t.integer  "rank",                 default: 0
    t.string   "name"
    t.string   "gender"
    t.string   "email"
    t.string   "password"
    t.string   "mugshot"
    t.string   "link"
    t.string   "locale"
    t.integer  "level",                default: 0
    t.integer  "manager"
    t.string   "last_ip"
    t.string   "country_code"
    t.integer  "remote_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "tr8n_translators", ["created_at"], name: "tr8n_t_c"
  add_index "tr8n_translators", ["email"], name: "tr8n_t_e"
  add_index "tr8n_translators", ["user_id"], name: "tr8n_t_u"

  create_table "user_follows", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "followed_user_id"
    t.integer  "user_id"
  end

  add_index "user_follows", ["followed_user_id"], name: "index_user_follows_on_followed_user_id"
  add_index "user_follows", ["user_id"], name: "index_user_follows_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.boolean  "is_admin",            default: false
    t.text     "facebook_friend_ids"
    t.string   "email"
    t.integer  "city_id"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "email_confirmed"
    t.string   "locale"
    t.string   "single_access_token"
    t.string   "nickname"
    t.string   "invitation_code"
    t.boolean  "restricted_access",   default: false
    t.string   "location"
    t.integer  "karma",               default: 0
    t.integer  "notifications_count", default: 0
    t.integer  "memberships_count",   default: 0
    t.datetime "last_notified"
    t.binary   "settings"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id"
  add_index "users", ["email"], name: "index_users_on_email"

  create_table "wave_items", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wave_id"
    t.integer  "user_id"
  end

  add_index "wave_items", ["user_id"], name: "index_wave_items_on_user_id"
  add_index "wave_items", ["wave_id"], name: "index_wave_items_on_wave_id"

  create_table "wave_memberships", force: true do |t|
    t.integer "wave_id"
    t.integer "user_id"
  end

  add_index "wave_memberships", ["user_id"], name: "index_wave_memberships_on_user_id"
  add_index "wave_memberships", ["wave_id"], name: "index_wave_memberships_on_wave_id"

  create_table "wave_notes", force: true do |t|
    t.string   "is_mailed",  default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wave_id"
    t.integer  "user_id"
  end

  add_index "wave_notes", ["user_id"], name: "index_wave_notes_on_user_id"
  add_index "wave_notes", ["wave_id"], name: "index_wave_notes_on_wave_id"

  create_table "waves", force: true do |t|
    t.string   "subject"
    t.datetime "last_changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "event_id"
  end

  add_index "waves", ["event_id"], name: "index_waves_on_event_id"
  add_index "waves", ["group_id"], name: "index_waves_on_group_id"
  add_index "waves", ["user_id"], name: "index_waves_on_user_id"

  create_table "will_filter_filters", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "data"
    t.integer  "user_id"
    t.string   "model_class_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "will_filter_filters", ["user_id"], name: "index_will_filter_filters_on_user_id"

end
