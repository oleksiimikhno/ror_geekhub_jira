class AddTasksCountToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :tasks_count, :integer, null: false, default: 0
  end
end
