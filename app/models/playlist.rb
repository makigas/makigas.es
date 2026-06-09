# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id                      :integer          not null, primary key
#  aggregated_trend_tag    :string
#  aggregated_views_recent :bigint           default(0), not null
#  aggregated_views_total  :bigint           default(0), not null
#  card_content_type       :string
#  card_file_name          :string
#  card_file_size          :bigint
#  card_updated_at         :datetime
#  deprecated              :boolean          default(FALSE), not null
#  description             :text             not null
#  excerpt                 :text
#  exclude_from_search     :boolean          default(FALSE), not null
#  forum_url               :string
#  normalized_views_recent :bigint           default(0), not null
#  normalized_views_total  :bigint           default(0), not null
#  slug                    :string           not null
#  thumbnail_content_type  :string
#  thumbnail_file_name     :string
#  thumbnail_file_size     :bigint
#  thumbnail_updated_at    :datetime
#  title                   :string           not null
#  topic_position          :integer          default(0), not null
#  views_recent            :integer          default(0)
#  views_total             :integer          default(0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  replacement_playlist_id :bigint
#  topic_id                :integer
#  youtube_id              :string           not null
#
# Indexes
#
#  index_playlists_on_replacement_playlist_id  (replacement_playlist_id)
#  index_playlists_on_slug                     (slug) UNIQUE
#  index_playlists_on_topic_id                 (topic_id)
#
class Playlist < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: %i[slugged history]

  acts_as_list scope: :topic, column: :topic_position

  has_attached_file :thumbnail, styles: {
    thumbnail: '100x100>',
    small: '180x180>',
    default: '360x360>',
    hidef: '720x720>'
  }, default_url: '/icons/color/makigas-512.png'

  has_attached_file :card, styles: {
    thumbnail: '320x180>',
    small: '640x360>',
    default: '1280x720>'
  }

  scope :sort_by_latest_video, lambda {
    joins(:videos).group('playlists.id').order(Arel.sql('max(videos.published_at) desc'))
  }

  # At least a video must have been published already.
  scope :with_public_videos, lambda {
    with_public_videos = joins(:videos).where(videos: { published_at: ..DateTime.current })
    Playlist.where(id: with_public_videos.pluck(:id))
  }

  scope :searchable, lambda {
    with_public_videos.includes(:videos).where(exclude_from_search: false)
  }

  def searchable?
    !exclude_from_search && videos.where(published_at: ..DateTime.current).present?
  end

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 100 }
  validates :thumbnail, presence: true
  validates :card, presence: true
  validates_attachment :thumbnail, content_type: { content_type: %r{\Aimage/.*\z} }
  validates_attachment :card, content_type: { content_type: %r{\Aimage/.*\z} }

  has_many :videos, -> { order(position: :asc) }, inverse_of: :playlist, dependent: :destroy
  belongs_to :topic, optional: true

  belongs_to :replacement_playlist, class_name: 'Playlist', optional: true

  include Meilisearch::Rails

  meilisearch enqueue: true, raise_on_failure: Rails.env.development?, if: :searchable? do
    attribute :title, :description, :excerpt, :slug, :views_recent, :views_total, :deprecated

    attribute(:last_publication_date) { videos.pluck(:published_at).max.to_i }
    attribute(:episode_titles) { videos.pluck(:title) }
    attribute(:episode_tags) { videos.pluck(:tags).flatten.uniq }

    attribute(:has_show_notes) do
      # every episode has show notes
      videos = Video.searchable.where(playlist_id: id)
      show_notes = ShowNote.where(documentable: videos)
      show_notes.count == videos.count
    end

    searchable_attributes %i[
      title description excerpt slug
      episode_titles episode_tags
    ]
    filterable_attributes %i[episode_tags last_publication_date deprecated has_show_notes]
    sortable_attributes %i[views_recent views_total last_publication_date]

    ranking_rules %i[sort exactness attribute last_publication_date:desc views_recent:desc words typo proximity]
  end

  def display_forum_url
    return forum_url if forum_url.present?

    return nil if topic.blank?

    all_topics = topic.ancestors.tap { |arr| arr << topic }
    all_urls = all_topics.map(&:forum_url)
    all_urls.reverse.compact.first
  end

  def total_length
    videos.map(&:duration).reduce(0, :+)
  end

  def to_s
    title
  end

  def content_updated_at
    [updated_at, videos.pluck(:updated_at).max].compact.flatten.max
  end

  # Returns a HATEOAS-friendly representation of the thumbnails.
  def icons
    %i[hidef default thumbnail].map do |style|
      { href: thumbnail.url(style),
        type: thumbnail.content_type,
        sizes: thumbnail.styles[style].geometry.gsub('>', '') }
    end
  end

  # Returns a HATEOAS-friendly representation of the cards
  def cards
    %i[default small thumbnail].map do |style|
      { href: card.url(style),
        type: card.content_type,
        sizes: card.styles[style].geometry.gsub('>', '') }
    end
  end

  def video_views_recent
    videos.pluck(:views_recent).sum
  end

  def video_views_total
    videos.pluck(:views_total).sum
  end
end
