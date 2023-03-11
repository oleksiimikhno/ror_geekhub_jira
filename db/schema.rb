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

ActiveRecord::Schema[7.0].define(version: 20_230_311_153_803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'comments', force: :cascade do |t|
    t.string 'body'
    t.bigint 'task_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id', null: false
    t.index ['task_id'], name: 'index_comments_on_task_id'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'descs', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'desks', force: :cascade do |t|
    t.string 'name'
    t.bigint 'project_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['project_id'], name: 'index_desks_on_project_id'
  end

  create_table 'projects', force: :cascade do |t|
    t.string 'name'
    t.integer 'status', default: 0
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_projects_on_user_id'
  end

  create_table 'tasks', force: :cascade do |t|
    t.text 'title'
    t.string 'description'
    t.integer 'priority', default: 0
    t.integer 'status', default: 0
    t.text 'label'
    t.datetime 'estimate'
    t.date 'start'
    t.date 'end'
    t.integer 'assignee_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id', null: false
    t.bigint 'project_id', null: false
    t.bigint 'desk_id', null: false
    t.integer 'type', default: 0
    t.index ['desk_id'], name: 'index_tasks_on_desk_id'
    t.index ['project_id'], name: 'index_tasks_on_project_id'
    t.index ['user_id'], name: 'index_tasks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'password_digest'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'last_name'
    t.string 'email'
  end

  add_foreign_key 'comments', 'tasks'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'desks', 'projects'
  add_foreign_key 'projects', 'users'
  add_foreign_key 'tasks', 'desks'
  add_foreign_key 'tasks', 'projects'
  add_foreign_key 'tasks', 'users'
end
