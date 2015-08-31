class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.string    :title,         null: false, default: ""
      t.text      :topics,        null: false, default: ""
      t.datetime  :starts_at
      t.datetime  :ends_at
      t.string    :venue,         null: false, default: ""
      t.integer   :max_members,   null: false, default: 1
      t.integer   :user_id

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :meetings
  end
end
