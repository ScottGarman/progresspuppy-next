class RemoveTaskCategoryForeignKey < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :tasks, :task_categories
  end
end
