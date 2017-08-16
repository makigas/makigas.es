# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :integer
#  url         :string
#  description :string
#
# Indexes
#
#  index_links_on_video_id  (video_id)
#

FactoryGirl.define do
  factory :link do
    association :video, factory: :video
    url 'https://www.ruby-lang.org'
    description 'Official website for the Ruby programming language'
  end
end
