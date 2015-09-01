class ChangeAvatarColName < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.rename :avatar_file_name, :user_photo_file_name
      t.rename :avatar_content_type, :user_photo_content_type
      t.rename :avatar_file_size, :user_photo_file_size
      t.rename :avatar_updated_at, :user_photo_updated_at
    end
  end

  def self.down
    change_table :users do |t|
      t.rename :user_photo_file_name, :avatar_file_name
      t.rename :user_photo_content_type, :avatar_content_type
      t.rename :user_photo_file_size, :avatar_file_size
      t.rename :user_photo_updated_at, :avatar_updated_at
    end
  end
end
