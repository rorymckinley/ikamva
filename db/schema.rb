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

ActiveRecord::Schema.define(:version => 20110204192531) do

  create_table "attendance_details", :force => true do |t|
    t.integer  "event_id"
    t.integer  "member_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "branches", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.string   "purpose"
    t.integer  "branch_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade"
  end

  create_table "members", :force => true do |t|
    t.string   "card_number"
    t.string   "participation"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "surname"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "mobile_number"
    t.string   "parent_guardian_number"
    t.boolean  "disabilities"
    t.string   "address"
    t.string   "school"
    t.string   "grade"
    t.string   "email"
    t.string   "id_number"
    t.string   "citizenship"
    t.string   "parent_guardian_1_relationship"
    t.string   "parent_guardian_2_relationship"
    t.string   "parent_guardian_1_job"
    t.string   "parent_guardian_2_job"
    t.text     "subjects"
    t.text     "ikamvanite_family_members"
  end

end
