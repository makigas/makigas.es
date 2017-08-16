# == Schema Information
#
# Table name: videos
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             not null
#  youtube_id   :string           not null
#  duration     :integer          not null
#  slug         :string           not null
#  playlist_id  :integer          not null
#  position     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  unfeatured   :boolean          default(FALSE), not null
#  published_at :datetime         not null
#  private      :boolean          default(FALSE), not null
#
# Indexes
#
#  index_videos_on_slug        (slug)
#  index_videos_on_youtube_id  (youtube_id) UNIQUE
#

FactoryGirl.define do
  factory :video do
    title 'Chandelier'
    description 'Music video for Chandelier'
    youtube_id '2vjPBrBU-TM'
    duration 232
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
