# == Schema Information
#
# Table name: topics
#
#  id                     :integer          not null, primary key
#  title                  :string           not null
#  description            :string           not null
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  color                  :string
#
# Indexes
#
#  index_topics_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :topic do
    title 'Popular musics'
    description 'Popular musics of all kinds of styles and genres'
    thumbnail { fixture_file_upload(Rails.root.join('spec/fixtures/topic.png'), 'image/png') }
    color '#55ff55'
  end
end
