# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                     :integer          not null, primary key
#  color                  :string
#  description            :string           not null
#  forum_url              :string
#  slug                   :string           not null
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :bigint
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  parent_topic_id        :bigint
#
# Indexes
#
#  index_topics_on_parent_topic_id  (parent_topic_id)
#  index_topics_on_slug             (slug) UNIQUE
#
class Topic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :parent_topic, class_name: 'Topic', optional: true
  has_many :child_topics, class_name: 'Topic', inverse_of: :parent_topic, foreign_key: :parent_topic_id,
                          dependent: :nullify

  THUMBNAIL_VARIANTS = {
    thumbnail: [100, 100],
    small: [180, 180],
    default: [360, 360],
    hidef: [720, 720]
  }.freeze

  has_one_attached :thumbnail

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :color, presence: true
  validates :thumbnail, image_attachment: true

  # Playlists can survive without a topic, so on delete set the topic to null.
  has_many :playlists, dependent: :nullify

  def playlists_with_children
    my_playlists = Playlist.where(topic_id: id)
    child_topics = Topic.where(parent_topic_id: id)
    child_playlists = Playlist.where(topic_id: child_topics)
    my_playlists.or(child_playlists)
  end

  def content_updated_at
    [updated_at, playlists.pluck(:updated_at).max].compact.flatten.max
  end

  def ancestors
    return [] if parent_topic_id.blank?

    parent_topic.ancestors.tap { |arr| arr << parent_topic }
  end

  def to_s
    title
  end

  # Returns a HATEOAS-friendly representation of the thumbnails.
  def icons
    %i[hidef default thumbnail].map do |style|
      { attachment: thumbnail_variant(style),
        type: thumbnail.blob.content_type,
        sizes: THUMBNAIL_VARIANTS.fetch(style).join('x') }
    end
  end

  def thumbnail_variant(style)
    thumbnail.variant(resize_to_limit: THUMBNAIL_VARIANTS.fetch(style), format: thumbnail_format)
  end

  private

  def thumbnail_format
    variant_format(thumbnail)
  end

  def variant_format(attachment)
    { 'image/jpeg' => 'jpg', 'image/png' => 'png', 'image/gif' => 'gif', 'image/webp' => 'webp',
      'image/tiff' => 'tiff', 'image/bmp' => 'bmp' }.fetch(attachment.blob.content_type) do
      attachment.blob.filename.extension_without_delimiter.presence&.downcase || 'png'
    end
  end
end
