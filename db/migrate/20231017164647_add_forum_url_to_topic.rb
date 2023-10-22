# frozen_string_literal: true

class AddForumUrlToTopic < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :forum_url, :string
  end
end
