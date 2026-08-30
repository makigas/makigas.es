# frozen_string_literal: true

class RemovePaperclipAttachmentColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :playlists, :card_content_type, :string
    remove_column :playlists, :card_file_name, :string
    remove_column :playlists, :card_file_size, :bigint
    remove_column :playlists, :card_updated_at, :datetime
    remove_column :playlists, :thumbnail_content_type, :string
    remove_column :playlists, :thumbnail_file_name, :string
    remove_column :playlists, :thumbnail_file_size, :bigint
    remove_column :playlists, :thumbnail_updated_at, :datetime

    remove_column :tags, :icon_content_type, :string
    remove_column :tags, :icon_file_name, :string
    remove_column :tags, :icon_file_size, :bigint
    remove_column :tags, :icon_updated_at, :datetime

    remove_column :topics, :thumbnail_content_type, :string
    remove_column :topics, :thumbnail_file_name, :string
    remove_column :topics, :thumbnail_file_size, :bigint
    remove_column :topics, :thumbnail_updated_at, :datetime
  end
end
