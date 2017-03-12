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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170311040153) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",         null: false
    t.string   "encrypted_password",     limit: 255, default: "",         null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "role",                   limit: 255, default: "pre_sale"
    t.string   "user_name",              limit: 255
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["user_name"], name: "index_admin_users_on_user_name", unique: true, using: :btree

  create_table "company_profiles", force: :cascade do |t|
    t.string   "company_name",      limit: 255
    t.string   "company_addr",      limit: 255
    t.string   "postcode",          limit: 255
    t.string   "company_desc",      limit: 255
    t.string   "contact",           limit: 255
    t.string   "primary_phone",     limit: 255
    t.string   "secondary_phone",   limit: 255
    t.string   "distribution_list", limit: 255
    t.string   "appendix",          limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "companyable_id",    limit: 4
    t.string   "companyable_type",  limit: 255
  end

  create_table "distributors", primary_key: "d_id", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "status",     limit: 255
    t.string   "type",       limit: 255
    t.string   "comment",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "equipment", force: :cascade do |t|
    t.string   "category",   limit: 255, default: "Other", null: false
    t.string   "model",      limit: 255,                   null: false
    t.string   "desc",       limit: 255
    t.string   "bom_id",     limit: 255
    t.integer  "amount",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment_parts", force: :cascade do |t|
    t.integer  "equipment_id", limit: 4
    t.string   "sn_no",        limit: 255
    t.string   "status",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iou_id",       limit: 4
  end

  add_index "equipment_parts", ["iou_id"], name: "index_equipment_parts_on_iou_id", using: :btree

  create_table "iou_items", force: :cascade do |t|
    t.integer  "iou_id",            limit: 4
    t.integer  "equipment_id",      limit: 4
    t.integer  "equipment_part_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "ious", force: :cascade do |t|
    t.integer  "distributor_id",            limit: 4
    t.string   "sales_name",                limit: 255
    t.date     "start_time_of_loan"
    t.date     "expected_end_time_of_loan"
    t.string   "status",                    limit: 255
    t.string   "contact_of_loaner",         limit: 255
    t.string   "phone_of_loaner",           limit: 255
    t.string   "approver",                  limit: 255
    t.string   "appendix",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ious", ["distributor_id"], name: "index_ious_on_distributor_id", using: :btree

end
