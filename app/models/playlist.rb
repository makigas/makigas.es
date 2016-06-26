class Playlist < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 100 }

  has_attached_file :photo, styles: { hd: "1280x720>", hq: "854x480>", md: "480x270>", thumbnail: "160x90>" }
  validates_attachment :photo, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..2.megabytes }

  has_many :videos, -> { order(position: :asc) }

  rails_admin do
    list do
      field :title
      field :description
    end

    edit do
      field :title
      field :description
      field :youtube_id do
        label 'Playlist ID'
      end
      field :photo
    end

    configure :youtube_id do
      label 'Playlist ID'
    end
  end
end
