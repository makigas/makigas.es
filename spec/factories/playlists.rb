# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    title { 'Popular music videos' }
    description { 'This list contains a lot of musical videos' }
    youtube_id { 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/playlist.png', 'image/png') }
    card { Rack::Test::UploadedFile.new('spec/fixtures/card.jpg', 'image/jpeg') }
    association :topic, factory: :topic
  end
end
