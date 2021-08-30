# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    user = build(:user)
    expect(user).to be_valid
  end

  describe 'validation' do
    it 'is not valid without e-mail' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid if the e-mail is already present' do
      create(:user, email: 'email1@example.com')
      user2 = build(:user, email: 'email1@example.com')
      expect(user2).not_to be_valid
    end
  end
end
