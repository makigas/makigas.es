# frozen_string_literal: true

class AddPublishedAtToVideos < ActiveRecord::Migration[5.0]
  def self.up
    # First, add this column as nullable.
    add_column :videos, :published_at, :datetime, null: true

    # Fill the value for every video.
    Video.find_each do |video|
      video.update(published_at: video.created_at)
    end

    # Make the column not nullable then.
    change_column :videos, :published_at, :datetime, null: false
  end

  def self.down
    remove_column :videos, :published_at, :datetime
  end
end
