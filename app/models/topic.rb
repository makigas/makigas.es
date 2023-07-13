# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                     :integer          not null, primary key
#  color                  :string
#  description            :string           not null
#  slug                   :string           not null
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :bigint
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_topics_on_slug  (slug) UNIQUE
#
class Topic < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_attached_file :thumbnail, styles: {
    thumbnail: '100x100>',
    small: '180x180>',
    default: '360x360>',
    hidef: '720x720>'
  }, default_url: '/makigas.png'

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

  # Returns a HATEOAS-friendly representation of the thumbnails.
  def icons
    %i[hidef default thumbnail].map do |style|
      { href: thumbnail.url(style),
        type: thumbnail.content_type,
        sizes: thumbnail.styles[style].geometry.gsub('>', '') }
    end
  end
end
