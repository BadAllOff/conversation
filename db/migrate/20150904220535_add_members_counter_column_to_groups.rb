class AddMembersCounterColumnToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :members_counter, :integer, default: 1
  end

  def self.down
    remove_column :groups, :members_counter, :integer, default: 1
  end
end
