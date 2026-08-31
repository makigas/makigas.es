# frozen_string_literal: true

class RemoveTopics < ActiveRecord::Migration[8.1]
  def up
    purge_topic_attachments

    remove_index :playlists, :topic_id if index_exists?(:playlists, :topic_id)
    remove_column :playlists, :topic_id, :integer
    remove_column :playlists, :topic_position, :integer
    drop_table :topics
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Topic data was deleted'
  end

  private

  def purge_topic_attachments
    return unless table_exists?(:active_storage_attachments)

    ActiveStorage::Attachment.where(record_type: 'Topic').find_each(&:purge)
  end
end
