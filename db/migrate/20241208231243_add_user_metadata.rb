# frozen_string_literal: true

class AddUserMetadata < ActiveRecord::Migration[7.2]
  def change
    change_table :users do |t|
      t.string :name, limit: 1024, null: true
      t.string :bio, limit: 1024, null: true
      t.string :twitter_url, limit: 1024, null: true
      t.string :github_url, limit: 1024, null: true
      t.string :mastodon_url, limit: 1024, null: true
      t.string :stack_overflow_url, limit: 1024, null: true
      t.string :linkedin_url, limit: 1024, null: true
      t.string :youtube_url, limit: 1024, null: true
      t.string :twitch_url, limit: 1024, null: true
      t.string :bluesky_url, limit: 1024, null: true
      t.string :external_url, limit: 1024, null: true
      t.string :fediverse_creator_id, limit: 1024, null: true
    end
  end
end
