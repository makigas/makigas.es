class Video < ActiveRecord::Base
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
  has_attached_file :thumbnail, styles: { hd: "1280x720>", hq: "854x480>", md: "480x270>", mini: "160x90>" }
  validates_attachment :thumbnail, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..2.megabytes }

  # Natural duration
  def natural_duration= dur
    self.duration = ApplicationController.helpers.extract_time dur
  end

  def natural_duration
    ApplicationController.helpers.running_time self.duration if self.duration
  end

  rails_admin do
    list do
      field :title
      field :playlist
      field :position
    end

    edit do
      field :title
      field :description
      field :youtube_id
      field :playlist
      field :duration, :duration
      field :thumbnail
      field :position
    end

    configure :youtube_id do
      label 'Playlist ID'
    end
  end
end
