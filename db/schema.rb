# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_08_112813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "workout_logs", force: :cascade do |t|
    t.integer "intensity"
    t.text "notes"
    t.datetime "workout_date"
    t.string "category"
    t.text "pains"
    t.string "recording_id"
  end

end
