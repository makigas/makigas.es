# == Schema Information
#
# Table name: tags
#
#  id                :bigint           not null, primary key
#  description       :string           not null
#  icon_content_type :string
#  icon_file_name    :string
#  icon_file_size    :bigint
#  icon_updated_at   :datetime
#  slug              :string           not null
#  synonyms          :string           default([]), not null, is an Array
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_tags_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :tag do
    title { 'Git' }
    description { 'Git es uno de los sistemas de control de versiones más populares en este momento, así que conocerlo te garantiza un sitio en la industria' }
    icon { Rack::Test::UploadedFile.new('spec/fixtures/tag.png') }
  end
end
