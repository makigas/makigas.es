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
#  parent_topic_id        :bigint
#
# Indexes
#
#  index_topics_on_parent_topic_id  (parent_topic_id)
#  index_topics_on_slug             (slug) UNIQUE
#
FactoryBot.define do
  factory :topic do
    sequence(:title) { |n| "Topic #{n}" }
    description { 'Popular musics of all kinds of styles and genres' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/topic.png', 'image/png') }
    color { '#55ff55' }
    slug { title&.parameterize }
  end
end
