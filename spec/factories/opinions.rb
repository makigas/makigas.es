FactoryBot.define do
  factory :opinion do
    from 'Programación & Co.'
    message 'Estamos encantados con el trabajo que hace este chico.'
    url 'https://www.example.com'
    photo { fixture_file_upload(Rails.root.join('spec/fixtures/opinion.png'), 'image/png') }
  end
end
