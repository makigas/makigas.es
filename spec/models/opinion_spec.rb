require 'rails_helper'

RSpec.describe Opinion, type: :model do

  it 'has a valid factory' do
    opinion = FactoryBot.build(:opinion)
    expect(opinion).to be_valid
  end

  describe 'validation' do
    it 'is not valid without a name from' do
      opinion = FactoryBot.build(:opinion, from: nil)
      expect(opinion).not_to be_valid
    end

    it 'is not valid without a message' do
      opinion = FactoryBot.build(:opinion, message: nil)
      expect(opinion).not_to be_valid
    end

    it 'is valid without an URL' do
      opinion = FactoryBot.build(:opinion, url: nil)
      expect(opinion).to be_valid
    end

    it 'is not valid without a photo' do
      opinion = FactoryBot.build(:opinion, photo: nil)
      expect(opinion).not_to be_valid
    end
  end

end
