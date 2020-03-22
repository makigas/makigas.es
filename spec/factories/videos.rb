# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    title { 'Chandelier' }
    description { 'Music video for Chandelier' }
    youtube_id { '2vjPBrBU-TM' }
    duration { 232 }
    association :playlist, factory: :playlist
    published_at { DateTime.now }

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
