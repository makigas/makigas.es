FactoryGirl.define do
  factory :topic do
    title 'Popular musics'
    description 'Popular musics of all kinds of styles and genres'
    photo { fixture_file_upload(Rails.root.join('spec/fixtures/topic.jpg'), 'image/jpeg') }
  end
end
