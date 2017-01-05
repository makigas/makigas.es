class Video < ApplicationRecord
  extend FriendlyId

  # Videos are sorted in a playlist.
  belongs_to :playlist
  acts_as_list scope: :playlist

  # Slug. Can be repeated as long as it's on different playlists.
  friendly_id :title, use: [:slugged, :scoped], scope: :playlist

  # Validations.
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 15 }
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :playlist, presence: true

  # Natural duration
  def natural_duration= dur
    self.duration = ApplicationController.helpers.extract_time dur
  end

  def natural_duration
    if duration
      "%02d:%02d:%02d" % [duration / 3600, (duration % 3600) / 60, duration % 60]
    end
  end

  def to_s
    title
  end
end
