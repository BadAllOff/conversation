class AddNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :surname, :string, null: false, default: ""
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :surname
  end
end
