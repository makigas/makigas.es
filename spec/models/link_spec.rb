# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_id    :integer
#  url         :string
#  description :string
#
# Indexes
#
#  index_links_on_video_id  (video_id)
#

require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'has a valid factory' do
    subject { FactoryGirl.build(:link) }
    it { is_expected.to be_valid }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of :url }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :video }
    it { is_expected.to validate_length_of(:url).is_at_most 1024 }
    it { is_expected.to validate_length_of(:description).is_at_most 256 }
  end

  context 'relationship' do
    it { is_expected.to belong_to :video }
  end
end
