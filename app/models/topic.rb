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

  has_attached_file :thumbnail, styles: {
    thumbnail: '100x100>',
    small: '180x180>',
    default: '360x360>',
    hidef: '720x720>'
  }, default_url: '/makigas.png'

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :color, presence: true
  validates :thumbnail, presence: true
  validates_attachment :thumbnail, content_type: { content_type: %r{\Aimage/.*\z} }

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
      { href: thumbnail.url(style),
        type: thumbnail.content_type,
        sizes: thumbnail.styles[style].geometry.gsub('>', '') }
    end
  end
end
