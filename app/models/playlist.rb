# frozen_string_literal: true

class Playlist < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_attached_file :thumbnail, styles: {
    thumbnail: '100x100>',
    small: '180x180>',
    default: '360x360>',
    hidef: '720x720>'
  }, default_url: '/makigas.png'

  has_attached_file :card, styles: {
    thumbnail: '320x180>',
    small: '640x360>',
    default: '1280x720>'
  }

  scope :sort_by_latest_video, lambda {
    joins(:videos).group('playlists.id').order(Arel.sql('max(videos.published_at) desc'))
  }

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1500 }
  validates :youtube_id, presence: true, length: { maximum: 100 }
  validates :thumbnail, presence: true
  validates :card, presence: true
  validates_attachment :thumbnail, content_type: { content_type: %r{\Aimage/.*\z} }
  validates_attachment :card, content_type: { content_type: %r{\Aimage/.*\z} }

  has_many :videos, -> { order(position: :asc) }, inverse_of: :playlist, dependent: :destroy
  belongs_to :topic, optional: true

  def total_length
    videos.map(&:duration).reduce(0, :+)
  end

  def to_s
    title
  end

  # Returns a HATEOAS-friendly representation of the thumbnails.
  def icons
    %i[hidef default thumbnail].map do |style|
      { href: thumbnail.url(style),
        type: thumbnail.content_type,
        sizes: thumbnail.styles[style].geometry.gsub('>', '') }
    end
  end

  # Returns a HATEOAS-friendly representation of the cards
  def cards
    %i[default small thumbnail].map do |style|
      { href: card.url(style),
        type: card.content_type,
        sizes: card.styles[style].geometry.gsub('>', '') }
    end
  end
end
