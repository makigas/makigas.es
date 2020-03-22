# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Dashboard', type: :feature do
  before { Capybara.default_host = 'http://dashboard.example.com' }

  after { Capybara.default_host = 'http://www.example.com' }

  context 'when not logged in' do
    it 'is not success' do
      visit dashboard_path
      expect(page).to have_no_current_path dashboard_topics_path
    end
  end

  context 'when logged in' do
    it 'is success' do
      visit dashboard_path
      expect(page.status_code).to eq 200
    end
  end
end
