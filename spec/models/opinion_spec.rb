require 'rails_helper'

RSpec.describe Opinion, type: :model do
  
  it 'has a valid factory' do
    opinion = FactoryGirl.build(:opinion)
    expect(opinion).to be_valid
  end
  
  context 'validation' do
    it 'is not valid without a name from' do
      opinion = FactoryGirl.build(:opinion, from: nil)
      expect(opinion).not_to be_valid
    end

    it 'is not valid without a message' do
      opinion = FactoryGirl.build(:opinion, message: nil)
      expect(opinion).not_to be_valid
    end

    it 'is valid without an URL' do
      opinion = FactoryGirl.build(:opinion, url: nil)
      expect(opinion).to be_valid
    end

    it 'is not valid without a photo' do
      opinion = FactoryGirl.build(:opinion, photo: nil)
      expect(opinion).not_to be_valid
    end
  end

end
