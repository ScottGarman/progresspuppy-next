class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :summary, null: false
      t.integer :priority, default: 3, null: false
      t.string :status, default: "INCOMPLETE", null: false
      t.date :due_at
      t.datetime :completed_at
      t.references :task_category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
