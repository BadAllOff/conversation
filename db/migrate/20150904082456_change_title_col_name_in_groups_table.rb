class ChangeTitleColNameInGroupsTable < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.rename :title, :group_name
    end
  end

  def self.down
    change_table :groups do |t|
      t.rename :group_name, :title
    end
  end
end
