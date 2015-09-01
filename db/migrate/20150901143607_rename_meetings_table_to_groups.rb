class RenameMeetingsTableToGroups < ActiveRecord::Migration
  def self.up
    rename_table :meetings, :groups
  end

  def self.down
    rename_table :groups, :meetings
  end
end
