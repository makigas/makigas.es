class Topic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }

  has_attached_file :photo, styles: { big: "800x800>", medium: "256x256>", thumb: "96x96>" }
  validates_attachment :photo, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { in: 0..2.megabytes }

  # Playlists can survive without a topic, so on delete set the topic to null.
  has_many :playlists, dependent: :nullify
end
