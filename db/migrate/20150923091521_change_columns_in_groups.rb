class ChangeColumnsInGroups < ActiveRecord::Migration
  def self.up
    change_column :groups, :latitude, :float, default: '40.36603994719198'
    change_column :groups, :longitude, :float, default: '49.83751684427261'
  end

  def self.down
    change_column :groups, :latitude, :float, default: nil
    change_column :groups, :longitude, :float, default: nil
  end
end
