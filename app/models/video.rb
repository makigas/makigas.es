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

  # Has thumbnail, which might be displayed through the site.
  has_attached_file :thumbnail, styles: { hd: "1280x720>", hq: "854x480>", md: "480x270>", mini_hdpi: "320x180>", mini: "160x90>" }
  validates_attachment :thumbnail, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..2.megabytes }

  # Natural duration
  def natural_duration= dur
    self.duration = ApplicationController.helpers.extract_time dur
  end

  def natural_duration
    if duration
      "%02d:%02d:%02d" % [duration / 3600, (duration % 3600) / 60, duration % 60]
    end
  end
end
