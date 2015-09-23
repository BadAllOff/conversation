class AddColumnToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :gmap_zoom, :integer, default: 14
  end
end
