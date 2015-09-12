class AddAcceptedByColumnToGroupMemberships < ActiveRecord::Migration
  def self.up
    add_column :group_memberships, :accepted_by, :integer, default: nil
  end

  def self.down
    remove_column :group_memberships, :accepted_by, :integer, default: nil
  end
end
