# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id                      :integer          not null, primary key
#  aggregated_trend_tag    :string
#  aggregated_views_recent :bigint           default(0), not null
#  aggregated_views_total  :bigint           default(0), not null
#  deprecated              :boolean          default(FALSE), not null
#  description             :text             not null
#  excerpt                 :text
#  exclude_from_search     :boolean          default(FALSE), not null
#  forum_url               :string
#  normalized_views_recent :bigint           default(0), not null
#  normalized_views_total  :bigint           default(0), not null
#  slug                    :string           not null
#  title                   :string           not null
#  topic_position          :integer          default(0), not null
#  views_recent            :integer          default(0)
#  views_total             :integer          default(0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  replacement_playlist_id :bigint
#  topic_id                :integer
#  youtube_id              :string           not null
#
# Indexes
#
#  index_playlists_on_replacement_playlist_id  (replacement_playlist_id)
#  index_playlists_on_slug                     (slug) UNIQUE
#  index_playlists_on_topic_id                 (topic_id)
#
FactoryBot.define do
  factory :playlist do
    sequence(:title) { |n| "Music videos, Volume #{n}" }
    description { 'This list contains a lot of musical videos' }
    youtube_id { 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI' }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/playlist.png', 'image/png') }
    card { Rack::Test::UploadedFile.new('spec/fixtures/card.jpg', 'image/jpeg') }
    slug { title&.parameterize }
    topic factory: %i[topic]
  end
end
