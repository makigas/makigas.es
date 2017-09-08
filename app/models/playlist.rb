# == Schema Information
#
# Table name: playlists
#
#  id                     :integer          not null, primary key
#  title                  :string           not null
#  description            :text             not null
#  youtube_id             :string           not null
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  topic_id               :integer
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  card_file_name         :string
#  card_content_type      :string
#  card_file_size         :integer
#  card_updated_at        :datetime
#
# Indexes
#
#  index_playlists_on_slug  (slug) UNIQUE
#

class Playlist < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_attached_file :thumbnail, styles: {
    thumbnail: "100x100>",
    small: "180x180>",
    default: "360x360>",
    hidef: "720x720>"
  }, default_url: "/makigas.png"
  
  has_attached_file :card, styles: {
    thumbnail: "320x180>",
    small: "640x360>",
    default: "1280x720>",
  }

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 100 }
  validates :thumbnail, presence: true
  validates :card, presence: true
  validates_attachment :thumbnail, content_type: { content_type: /\Aimage\/.*\z/ }
  validates_attachment :card, content_type: { content_type: /\Aimage\/.*\z/ }

  has_many :videos, -> { order(position: :asc) }
  belongs_to :topic, required: false
  
  def total_length
    videos.map { |v| v.duration }.reduce(0, :+)
  end

  def to_s
    title
  end
end
