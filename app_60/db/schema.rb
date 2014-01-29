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

ActiveRecord::Schema.define(version: 20140129174658) do

  create_table "audios", force: true do |t|
    t.integer  "narrative_id"
    t.string   "audio_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.integer  "narrative_id"
    t.string   "image_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "narratives", force: true do |t|
    t.string   "nar_name"
    t.string   "nar_path"
    t.integer  "language_id"
    t.integer  "category_id"
    t.string   "first_image"
    t.integer  "num_of_view"
    t.integer  "num_of_agree"
    t.integer  "num_of_disagree"
    t.integer  "num_of_flagged"
    t.datetime "create_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
