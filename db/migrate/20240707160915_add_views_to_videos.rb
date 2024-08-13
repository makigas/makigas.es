# frozen_string_literal: true

class AddViewsToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :views_total, :integer, default: 0
    add_column :videos, :views_recent, :integer, default: 0
  end
end
