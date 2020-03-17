class AddThumbnailToTopic < ActiveRecord::Migration[5.0]
  def up
    add_attachment :topics, :thumbnail
  end

  def down
    remove_attachment :topics, :thumbnail
  end
end
