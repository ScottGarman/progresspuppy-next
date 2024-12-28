class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :email_address_confirmed, :boolean, default: false
    add_column :users, :time_zone, :string
  end
end
