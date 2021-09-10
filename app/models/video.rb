# frozen_string_literal: true

class Video < ApplicationRecord
  extend FriendlyId

  # Videos are sorted in a playlist.
  belongs_to :playlist
  has_many :links, dependent: :destroy
  acts_as_list scope: :playlist

  # Slug. Can be repeated as long as it's on different playlists.
  friendly_id :title, use: %i[slugged scoped], scope: :playlist

  # Scope for limiting the amount of videos to those actually published.
  scope :visible, -> { where('published_at <= ?', DateTime.now) }

  # Validations.
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 15 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :playlist, presence: true
  validates :published_at, presence: true

  has_one :transcription, dependent: :destroy, as: :documentable

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
end
