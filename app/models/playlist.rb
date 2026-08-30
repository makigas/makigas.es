# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id                      :integer          not null, primary key
#  aggregated_trend_tag    :string
#  aggregated_views_recent :bigint           default(0), not null
#  aggregated_views_total  :bigint           default(0), not null
#  deprecated              :boolean          default(FALSE), not null
#  description             :text             not null
#  excerpt                 :text
#  exclude_from_search     :boolean          default(FALSE), not null
#  forum_url               :string
#  normalized_views_recent :bigint           default(0), not null
#  normalized_views_total  :bigint           default(0), not null
#  slug                    :string           not null
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
# rubocop:disable Metrics/ClassLength
class Playlist < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: %i[slugged history]

  acts_as_list scope: :topic, column: :topic_position

  THUMBNAIL_VARIANTS = {
    thumbnail: [100, 100],
    small: [180, 180],
    default: [360, 360],
    hidef: [720, 720]
  }.freeze

  CARD_VARIANTS = {
    thumbnail: [320, 180],
    small: [640, 360],
    default: [1280, 720]
  }.freeze

  has_one_attached :thumbnail
  has_one_attached :card

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
  validates :thumbnail, image_attachment: true
  validates :card, image_attachment: true

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
      { attachment: thumbnail_variant(style),
        type: thumbnail.blob.content_type,
        sizes: THUMBNAIL_VARIANTS.fetch(style).join('x') }
    end
  end

  # Returns a HATEOAS-friendly representation of the cards
  def cards
    %i[default small thumbnail].map do |style|
      { attachment: card_variant(style),
        type: card.blob.content_type,
        sizes: CARD_VARIANTS.fetch(style).join('x') }
    end
  end

  def thumbnail_variant(style)
    thumbnail.variant(resize_to_limit: THUMBNAIL_VARIANTS.fetch(style), format: thumbnail_format)
  end

  def card_variant(style)
    card.variant(resize_to_limit: CARD_VARIANTS.fetch(style), format: card_format)
  end

  private

  def thumbnail_format
    variant_format(thumbnail)
  end

  def card_format
    variant_format(card)
  end

  def variant_format(attachment)
    { 'image/jpeg' => 'jpg', 'image/png' => 'png', 'image/gif' => 'gif', 'image/webp' => 'webp',
      'image/tiff' => 'tiff', 'image/bmp' => 'bmp' }.fetch(attachment.blob.content_type) do
      attachment.blob.filename.extension_without_delimiter.presence&.downcase || 'png'
    end
  end

  public

  def video_views_recent
    videos.pluck(:views_recent).sum
  end

  def video_views_total
    videos.pluck(:views_total).sum
  end
end
# rubocop:enable Metrics/ClassLength
