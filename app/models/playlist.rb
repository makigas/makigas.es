# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id                     :integer          not null, primary key
#  card_content_type      :string
#  card_file_name         :string
#  card_file_size         :bigint
#  card_updated_at        :datetime
#  description            :text             not null
#  slug                   :string           not null
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :bigint
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  topic_id               :integer
#  youtube_id             :string           not null
#
# Indexes
#
#  index_playlists_on_slug      (slug) UNIQUE
#  index_playlists_on_topic_id  (topic_id)
#
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

  # Generate the CreativeWorkSeries schema for this Thing.
  # rubocop:disable Metrics/AbcSize
  def creative_work_series
    { name: title,
      description:,
      abstract: description,
      dateCreated: created_at.iso8601,
      dateModified: updated_at.iso8601,
      datePublished: videos.first&.published_at&.iso8601,
      keywords: videos.pluck(:tags).flatten.uniq,
      thumbnailUrl: thumbnail.url(:thumb),
      image: card.url(:default) }
  end
  # rubocop:enable Metrics/AbcSize
end
