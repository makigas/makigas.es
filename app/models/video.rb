# frozen_string_literal: true

class Video < ApplicationRecord
  extend FriendlyId

  include MeiliSearch
  meilisearch per_environment: true, raise_on_failure: Rails.env.development? do
    attribute :title, :description

    attribute(:transcription) do
      transcription&.content
    end

    attribute :slug

    attribute(:playlist_title) { playlist.title }
    attribute(:playlist_description) { playlist.description }
    attribute(:playlist_slug) { playlist.slug }

    attribute(:topic_title) { playlist.topic&.title }
    attribute(:topic_description) { playlist.topic&.description }
    attribute(:topic_slug) { playlist.topic&.slug }

    attribute :duration
    filterable_attributes %i[topic_slug duration]
  end

  # Videos are sorted in a playlist.
  belongs_to :playlist
  has_many :links, dependent: :destroy
  acts_as_list scope: :playlist

  # Slug. Can be repeated as long as it's on different playlists.
  friendly_id :title, use: %i[slugged scoped], scope: :playlist

  # Scope for limiting the amount of videos to those actually published.
  scope :visible, -> { where('published_at <= ?', DateTime.now) }

  # Filterable scopes
  scope :filter_by_length, ->(duration) { where(LENGTH_QUERIES[duration]) }
  scope :filter_by_topic, ->(slug) { includes(playlist: :topic).where('topic.slug' => slug) }

  # Validations.
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 15 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :playlist, presence: true
  validates :published_at, presence: true

  has_one :transcription, dependent: :destroy, as: :documentable

  def self.free_filter(filter_params)
    filter_params.to_h.reduce(Video.visible) do |videos, (key, value)|
      scope = "filter_by_#{key}"
      return videos unless videos.respond_to?(scope)

      videos.send(scope, value)
    end
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
end
