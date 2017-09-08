# == Schema Information
#
# Table name: playlists
#
#  id                     :integer          not null, primary key
#  title                  :string           not null
#  description            :text             not null
#  youtube_id             :string           not null
#  slug                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  topic_id               :integer
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  card_file_name         :string
#  card_content_type      :string
#  card_file_size         :integer
#  card_updated_at        :datetime
#
# Indexes
#
#  index_playlists_on_slug  (slug) UNIQUE
#

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :playlist do
    title 'Popular music videos'
    description 'This list contains a lot of musical videos'
    youtube_id 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI'
    thumbnail { fixture_file_upload(Rails.root.join('spec/fixtures/playlist.png'), 'image/png') }
    card { fixture_file_upload(Rails.root.join('spec/fixtures/card.jpg'), 'image/jpeg') }
    association :topic, factory: :topic
  end
end
