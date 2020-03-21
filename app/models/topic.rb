class Topic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_attached_file :thumbnail, styles: {
    thumbnail: "100x100>",
    small: "180x180>",
    default: "360x360>",
    hidef: "720x720>"
  }, default_url: "/makigas.png"

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :color, presence: true
  validates :thumbnail, presence: true
  validates_attachment :thumbnail, content_type: { content_type: %r{\Aimage/.*\z} }

  # Playlists can survive without a topic, so on delete set the topic to null.
  has_many :playlists, dependent: :nullify

  def to_s
    title
  end
end
