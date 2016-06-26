FactoryGirl.define do
  factory :video do
    title 'Chandelier'
    description 'Music video for Chandelier'
    youtube_id '2vjPBrBU-TM'
    duration 232
    thumbnail { fixture_file_upload(Rails.root.join('spec/fixtures/video.jpg'), 'image/jpeg') }
    association :playlist, factory: :playlist
    position 1
  end
end
