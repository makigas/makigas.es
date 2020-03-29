# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    sequence(:title) { |n| "Topic #{n}" }
    description { 'Popular musics of all kinds of styles and genres' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/topic.png', 'image/png') }
    color { '#55ff55' }
  end
end
