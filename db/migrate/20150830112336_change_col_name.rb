class ChangeColName < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.rename :name, :first_name
      t.rename :surname, :last_name
    end
  end

  def self.down
    change_table :users do |t|
      t.rename :first_name, :name
      t.rename  :last_name, :surname
    end
  end
end
