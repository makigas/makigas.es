# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  description  :text             not null
#  duration     :integer          not null
#  early_access :boolean          default(FALSE), not null
#  position     :integer          not null
#  published_at :datetime         not null
#  slug         :string           not null
#  tags         :string           default([]), is an Array
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  playlist_id  :integer          not null
#  twitch_id    :string
#  youtube_id   :string           not null
#
# Indexes
#
#  index_videos_on_early_access  (early_access)
#  index_videos_on_slug          (slug)
#  index_videos_on_youtube_id    (youtube_id) UNIQUE
#
class Video < ApplicationRecord
  extend FriendlyId

  include MeiliSearch::Rails
  meilisearch enqueue: true, raise_on_failure: Rails.env.development? do
    attribute :title, :description

    attribute(:transcription) { transcription&.content }
    attribute(:show_note) { show_note&.content }

    attribute :slug
    attribute :tags

    attribute(:playlist_title) { playlist.title }
    attribute(:playlist_description) { playlist.description }
    attribute(:playlist_slug) { playlist.slug }

    attribute(:topic_title) { playlist.topic&.title }
    attribute(:topic_description) { playlist.topic&.description }
    attribute(:topic_slug) { playlist.topic&.slug }

    attribute :duration
    filterable_attributes %i[topic_slug duration tags]
  end

  # Videos are sorted in a playlist.
  belongs_to :playlist
  has_many :links, dependent: :destroy
  acts_as_list scope: :playlist

  # Slug. Can be repeated as long as it's on different playlists.
  friendly_id :title, use: %i[slugged scoped], scope: :playlist

  # Scope for limiting the amount of videos to those actually published.
  scope :visible, -> { where('published_at <= ?', DateTime.now) }

  # Scope for getting videos that are available for early access.
  scope :early_access, lambda {
    where(early_access: true).where('published_at > ?', DateTime.now).where.not(twitch_id: nil)
  }

  # Filterable scopes
  scope :filter_by_length, ->(duration) { where(LENGTH_QUERIES[duration]) }
  scope :filter_by_topic, ->(slug) { includes(playlist: :topic).where('topic.slug' => slug) }
  scope :filter_by_tag, ->(tag) { tag ? where('tags @> ARRAY[?]::varchar[]', tag) : self }

  # Tags
  scope :untagged, -> { where("tags = '{}'") }

  # Validations.
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 15 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :published_at, presence: true

  has_one :show_note, dependent: :destroy, as: :documentable
  has_one :transcription, dependent: :destroy, as: :documentable

  def self.free_filter(filter_params)
    filter_params.to_h.reduce(Video.visible) do |videos, (key, value)|
      scope = "filter_by_#{key}"
      return videos unless videos.respond_to?(scope)

      videos.send(scope, value)
    end
  end

  def self.tags
    pluck(Arel.sql('DISTINCT unnest(tags)'))
  end

  # Natural duration
  def natural_duration=(dur)
    self.duration = ApplicationController.helpers.extract_time dur
  end

  def natural_duration
    return nil if duration.blank?

    hours = duration / 3600
    minutes = (duration % 3600) / 60
    seconds = duration % 60
    [hours.to_s.rjust(2, '0'), minutes.to_s.rjust(2, '0'), seconds.to_s.rjust(2, '0')].join(':')
  end

  # Visible videos are those whose publication date has been already reached.
  # Therefore this videos are visible on lists, playlists, searches...
  def visible?
    published_at <= DateTime.now
  end

  # Scheduled videos are those whose publication date has not been reached yet.
  # Showing content for this video would spoil the experience and therefore
  # they should be excluded from searches, lists, playlists...
  def scheduled?
    published_at > DateTime.now
  end

  def to_s
    title
  end

  LENGTH_QUERIES = {
    'short' => 'duration <= 300',
    'medium' => 'duration > 300 and duration <= 900',
    'long' => 'duration > 900'
  }.freeze

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def to_episode_schema
    { name: title,
      description:,
      keywords: tags,
      dateCreated: created_at.iso8601,
      dateModified: updated_at.iso8601,
      datePublished: published_at&.iso8601,
      timeRequired: schema_duration,
      duration: schema_duration,
      image: playlist.card.url(:default),
      thumbnailUrl: playlist.thumbnail.url(:thumb),
      episodeNumber: position }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def to_video_schema
    { name: title,
      description:,
      thumbnailUrl: "https://i1.ytimg.com/vi/#{youtube_id}/mqdefault.jpg",
      uploadDate: published_at ? published_at&.iso8601 : created_at.iso8601,
      duration: schema_duration,
      embedUrl: "https://www.youtube.com/embed/#{youtube_id}" }
  end

  def schema_duration
    ActiveSupport::Duration.build(duration).iso8601
  end
end
