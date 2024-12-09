# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  bio                    :string(1024)
#  bluesky_url            :string(1024)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  external_url           :string(1024)
#  github_url             :string(1024)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  linkedin_url           :string(1024)
#  mastodon_url           :string(1024)
#  name                   :string(1024)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  stack_overflow_url     :string(1024)
#  twitch_url             :string(1024)
#  twitter_url            :string(1024)
#  youtube_url            :string(1024)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  fediverse_creator_id   :string(1024)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
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
