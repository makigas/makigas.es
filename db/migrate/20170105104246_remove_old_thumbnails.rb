# frozen_string_literal: true

class RemoveOldThumbnails < ActiveRecord::Migration[5.0]
  def change
    remove_column :playlists, :photo_file_name, :string
    remove_column :playlists, :photo_content_type, :string
    remove_column :playlists, :photo_file_size, :integer
    remove_column :playlists, :photo_updated_at, :datetime

    remove_column :topics, :photo_file_name, :string
    remove_column :topics, :photo_content_type, :string
    remove_column :topics, :photo_file_size, :integer
    remove_column :topics, :photo_updated_at, :datetime

    remove_column :videos, :thumbnail_file_name, :string
    remove_column :videos, :thumbnail_content_type, :string
    remove_column :videos, :thumbnail_file_size, :integer
    remove_column :videos, :thumbnail_updated_at, :datetime
  end
end
