class ChangeUserPhotoColName < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.rename :user_photo_file_name,     :personal_photo_file_name
      t.rename :user_photo_content_type,  :personal_photo_content_type
      t.rename :user_photo_file_size,     :personal_photo_file_size
      t.rename :user_photo_updated_at,    :personal_photo_updated_at
    end
  end

  def self.down
    change_table :users do |t|
      t.rename :personal_photo_file_name,     :user_photo_file_name
      t.rename :personal_photo_content_type,  :user_photo_content_type
      t.rename :personal_photo_file_size,     :user_photo_file_size
      t.rename :personal_photo_updated_at,    :user_photo_updated_at
    end
  end
end

