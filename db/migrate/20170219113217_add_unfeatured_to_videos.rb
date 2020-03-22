# frozen_string_literal: true

class AddUnfeaturedToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :unfeatured, :boolean, null: false, default: false
  end
end
