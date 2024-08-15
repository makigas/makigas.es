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
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_tags_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validation' do
    it 'is not valid without a title' do
      tag = build(:tag, title: nil)
      expect(tag).not_to be_valid
    end

    it 'is not valid without a description' do
      tag = build(:tag, description: nil)
      expect(tag).not_to be_valid
    end

    it 'is not valid without an icon' do
      tag = build(:tag, icon: nil)
      expect(tag).not_to be_valid
    end
  end
end
