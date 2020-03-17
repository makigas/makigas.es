require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  describe 'validation' do
    it 'is not valid without e-mail' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid if the e-mail is already present' do
      user1 = FactoryBot.create(:user, email: 'email1@example.com')
      user2 = FactoryBot.build(:user, email: 'email1@example.com')
      expect(user2).not_to be_valid
    end
  end
end
