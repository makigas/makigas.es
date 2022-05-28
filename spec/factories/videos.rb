# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    title { 'Chandelier' }
    description { 'Music video for Chandelier' }
    tags { %w[music video] }
    youtube_id { |i| OpenSSL::Digest.hexdigest('SHA1', i.to_s)[0..10] }
    duration { 232 }
    association :playlist, factory: :playlist
    published_at { DateTime.now }
    slug { title&.parameterize }

    trait :published_yesterday do
      published_at { 1.day.ago }
    end

    trait :published_tomorrow do
      published_at { 1.day.from_now }
    end

    factory :yesterday_video, traits: [:published_yesterday]
    factory :tomorrow_video, traits: [:published_tomorrow]
  end
end
