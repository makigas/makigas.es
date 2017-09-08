# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    user = FactoryGirl.build(:user)
    expect(user).to be_valid
  end

  context 'validation' do
    it 'is not valid without e-mail' do
      user = FactoryGirl.build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user = FactoryGirl.build(:user, password: nil)
      expect(user).not_to be_valid
    end
    
    it 'is not valid if the e-mail is already present' do
      user1 = FactoryGirl.create(:user, email: 'email1@example.com')
      user2 = FactoryGirl.build(:user, email: 'email1@example.com')
      expect(user2).not_to be_valid
    end
  end
end
