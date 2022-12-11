# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  name        :string           not null
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :bigint           not null
#
# Indexes
#
#  index_links_on_video_id  (video_id)
#
require 'rails_helper'

RSpec.describe Link do
  describe 'factory' do
    it 'is valid' do
      link = build(:link)
      expect(link).to be_valid
    end
  end

  describe 'validation' do
    it 'is not valid without a name' do
      link = build(:link, name: nil)
      expect(link).not_to be_valid
    end

    it 'is not valid without a description' do
      link = build(:link, description: nil)
      expect(link).not_to be_valid
    end

    it 'is not valid without an URL' do
      link = build(:link, url: nil)
      expect(link).not_to be_valid
    end
  end

  describe 'relationships' do
    it 'belongs to a video' do
      link = build(:link)
      expect(link).to respond_to(:video)
    end
  end
end
