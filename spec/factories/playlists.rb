# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    sequence(:title) { |n| "Music videos, Volume #{n}" }
    description { 'This list contains a lot of musical videos' }
    youtube_id { 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/playlist.png', 'image/png') }
    card { Rack::Test::UploadedFile.new('spec/fixtures/card.jpg', 'image/jpeg') }
    slug { title&.parameterize }
    association :topic, factory: :topic
  end
end
