class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.boolean :email_confirmed, default: false
      t.string :time_zone
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email
  end
end
