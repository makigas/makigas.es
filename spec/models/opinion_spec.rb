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
#  photo_file_size    :bigint           not null
#  photo_updated_at   :datetime         not null
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'rails_helper'

RSpec.describe Opinion, type: :model do
  it 'has a valid factory' do
    opinion = build(:opinion)
    expect(opinion).to be_valid
  end

  describe 'validation' do
    it 'is not valid without a name from' do
      opinion = build(:opinion, from: nil)
      expect(opinion).not_to be_valid
    end

    it 'is not valid without a message' do
      opinion = build(:opinion, message: nil)
      expect(opinion).not_to be_valid
    end

    it 'is valid without an URL' do
      opinion = build(:opinion, url: nil)
      expect(opinion).to be_valid
    end

    it 'is not valid without a photo' do
      opinion = build(:opinion, photo: nil)
      expect(opinion).not_to be_valid
    end
  end
end
