class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes do |t|
      t.string :quotation, null: false
      t.string :source, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
