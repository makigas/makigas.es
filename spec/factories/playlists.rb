# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id                     :integer          not null, primary key
#  card_content_type      :string
#  card_file_name         :string
#  card_file_size         :integer
#  card_updated_at        :datetime
#  description            :text             not null
#  forum_url              :string
#  slug                   :string           not null
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  title                  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  topic_id               :integer
#  youtube_id             :string           not null
#
# Indexes
#
#  index_playlists_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :playlist do
    sequence(:title) { |n| "Music videos, Volume #{n}" }
    description { 'This list contains a lot of musical videos' }
    youtube_id { 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/playlist.png', 'image/png') }
    card { Rack::Test::UploadedFile.new('spec/fixtures/card.jpg', 'image/jpeg') }
    slug { title&.parameterize }
    topic factory: %i[topic]
  end
end
