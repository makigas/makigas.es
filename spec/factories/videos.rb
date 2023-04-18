# frozen_string_literal: true

# == Schema Information
#
# Table name: videos
#
#  id               :integer          not null, primary key
#  description      :text             not null
#  duration         :integer          not null
#  early_access     :boolean          default(FALSE), not null
#  old_playlist_ids :integer          default([]), not null, is an Array
#  position         :integer          not null
#  published_at     :datetime         not null
#  slug             :string           not null
#  tags             :string           default([]), is an Array
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  playlist_id      :integer          not null
#  twitch_id        :string
#  youtube_id       :string           not null
#
# Indexes
#
#  index_videos_on_early_access      (early_access)
#  index_videos_on_old_playlist_ids  (old_playlist_ids)
#  index_videos_on_slug              (slug)
#  index_videos_on_youtube_id        (youtube_id) UNIQUE
#
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
