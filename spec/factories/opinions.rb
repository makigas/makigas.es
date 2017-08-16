# == Schema Information
#
# Table name: opinions
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  from               :string           not null
#  message            :string           not null
#  url                :string
#  photo_file_name    :string           not null
#  photo_content_type :string           not null
#  photo_file_size    :integer          not null
#  photo_updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :opinion do
    from 'Programación & Co.'
    message 'Estamos encantados con el trabajo que hace este chico.'
    url 'https://www.example.com'
    photo { fixture_file_upload(Rails.root.join('spec/fixtures/opinion.png'), 'image/png') }
  end
end
