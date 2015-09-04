class AddPrivacyToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :privacy, :string, default: 'public'
  end

  def self.down
    remove_column :groups, :privacy, :string, default: 'public'
  end
end
