class AddColumnsToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :latitude, :float
    add_column :groups, :longitude, :float
  end
end
