class Topic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }

  # Playlists can survive without a topic, so on delete set the topic to null.
  has_many :playlists, dependent: :nullify
end
