class CreateSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :settings do |t|
      t.boolean :display_quotes, default: true
      t.boolean :burnination, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
