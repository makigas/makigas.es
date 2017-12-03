FactoryBot.define do
  factory :topic do
    title 'Popular musics'
    description 'Popular musics of all kinds of styles and genres'
    thumbnail { fixture_file_upload(Rails.root.join('spec/fixtures/topic.png'), 'image/png') }
    color '#55ff55'
  end
end
