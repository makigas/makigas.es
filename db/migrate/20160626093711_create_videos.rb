class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      # This is the basic information about the video.
      t.string :title, null: false, length: 100
      t.text :description, null: false, length: 1500
      t.string :youtube_id, null: false, length: 15

      t.integer :duration, null: false
      t.string :slug, null: false
      t.attachment :thumbnail
      
      # Videos are part of a playlist.
      t.belongs_to :playlist, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end
    
    # Slug cannot be unique this time since there might be repetitions.
    add_index :videos, :slug
    add_index :videos, :youtube_id, unique: true
  end
end
