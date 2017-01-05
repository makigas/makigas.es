class Playlist < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 100 }

  has_many :videos, -> { order(position: :asc) }
  belongs_to :topic
  
  def total_length
    videos.map { |v| v.duration }.reduce(0, :+)
  end

  def to_s
    title
  end
end
