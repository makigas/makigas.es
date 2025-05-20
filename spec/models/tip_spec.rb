# frozen_string_literal: true

# == Schema Information
#
# Table name: tips
#
#  id           :bigint           not null, primary key
#  content      :text             not null
#  description  :string           not null
#  published_at :datetime         not null
#  slug         :string
#  status       :string           default("draft"), not null
#  tags         :string           default([]), not null, is an Array
#  title        :string           not null
#  views_recent :integer          default(0)
#  views_total  :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  taxonomy_id  :bigint           not null
#  user_id      :bigint
#  youtube_id   :string
#
# Indexes
#
#  index_tips_on_published_at          (published_at)
#  index_tips_on_slug_and_taxonomy_id  (slug,taxonomy_id) UNIQUE
#  index_tips_on_tags                  (tags)
#  index_tips_on_taxonomy_id           (taxonomy_id)
#  index_tips_on_user_id               (user_id)
#  index_tips_on_youtube_id            (youtube_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Tip do
  describe 'validation' do
    it 'has a valid factory' do
      expect(build(:tip)).to be_valid
    end
  end
end
