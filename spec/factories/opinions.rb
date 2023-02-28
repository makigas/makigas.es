# frozen_string_literal: true

# == Schema Information
#
# Table name: opinions
#
#  id                 :integer          not null, primary key
#  from               :string           not null
#  message            :string           not null
#  photo_content_type :string           not null
#  photo_file_name    :string           not null
#  photo_file_size    :integer          not null
#  photo_updated_at   :datetime         not null
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :opinion do
    from { 'Programación & Co.' }
    message { 'Estamos encantados con el trabajo que hace este chico.' }
    url { 'https://www.example.com' }
    photo { Rack::Test::UploadedFile.new('spec/fixtures/opinion.png', 'image/png') }
  end
end
