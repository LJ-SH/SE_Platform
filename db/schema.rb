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

ActiveRecord::Schema.define(version: 20161218133942) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                   default: "pre_sale"
    t.string   "user_name"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["user_name"], name: "index_admin_users_on_user_name", unique: true, using: :btree

  create_table "company_profiles", force: true do |t|
    t.string   "company_name"
    t.string   "company_addr"
    t.string   "postcode"
    t.string   "company_desc"
    t.string   "contact"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.string   "distribution_list"
    t.string   "appendix"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "companyable_id"
    t.string   "companyable_type"
  end

  create_table "distributors", primary_key: "d_id", force: true do |t|
    t.string   "name"
    t.string   "status"
    t.string   "type"
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment", force: true do |t|
    t.string   "category",   default: "Other", null: false
    t.string   "model",                        null: false
    t.string   "desc"
    t.string   "bom_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment_parts", force: true do |t|
    t.integer  "equipment_id"
    t.string   "sn_no"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iou_id"
  end

  add_index "equipment_parts", ["iou_id"], name: "index_equipment_parts_on_iou_id", using: :btree

  create_table "ious", force: true do |t|
    t.integer  "distributor_id"
    t.string   "sales_name"
    t.date     "start_time_of_loan"
    t.date     "expected_end_time_of_loan"
    t.string   "status"
    t.string   "contact_of_loaner"
    t.string   "phone_of_loaner"
    t.string   "approver"
    t.string   "appendix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ious", ["distributor_id"], name: "index_ious_on_distributor_id", using: :btree

end
