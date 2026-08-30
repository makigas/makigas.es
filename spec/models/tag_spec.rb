# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  slug        :string           not null
#  synonyms    :string           default([]), not null, is an Array
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tags_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Tag do
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

  describe '#icon_variant' do
    it 'keeps the configured dimensions and source format' do
      tag = build(:tag)

      expect(tag.icon_variant(:default).variation.transformations).to eq(
        resize_to_limit: [64, 64], format: 'png'
      )
    end
  end
end
