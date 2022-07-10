# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  name        :string           not null
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :bigint           not null
#
# Indexes
#
#  index_links_on_video_id  (video_id)
#
FactoryBot.define do
  factory :link do
    name { 'Wikipedia' }
    description { 'Wikipedia es una página llena de recursos de aprendizaje' }
    url { 'https://es.wikipedia.org' }
    video
  end
end
