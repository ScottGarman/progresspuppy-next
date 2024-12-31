class CreateTaskCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :task_categories do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
