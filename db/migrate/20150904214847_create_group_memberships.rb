class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer   :group_id,        index: true
      t.integer   :user_id,         index: true
      t.string    :status,          default: 'pending'
      t.datetime  :admission_time

      t.timestamps null: false
    end

    add_index :group_memberships, [:group_id, :user_id], unique: true
  end

  def self.down
    remove_index :group_memberships, [:group_id, :user_id]
    remove_index :group_memberships, :group_id
    remove_index :group_memberships, :user_id
    drop_table :group_memberships
  end

end
