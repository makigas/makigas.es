include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :playlist do
    title 'Popular music videos'
    description 'This list contains a lot of musical videos'
    youtube_id 'PLFgquLnL59alCl_2TQvOiD5Vgm1hCaGSI'
    thumbnail { fixture_file_upload(Rails.root.join('spec/fixtures/playlist.png'), 'image/png') }
  end
end
