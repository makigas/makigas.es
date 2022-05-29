# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pending tags', type: :feature do
  before { Capybara.default_host = 'http://dashboard.example.com' }

  after { Capybara.default_host = 'http://www.example.com' }

  context 'when not logged in' do
    it 'is not accessible' do
      visit dashboard_pending_tags_path
      expect(page).not_to have_current_path dashboard_pending_tags_path
    end
  end

  context 'when logged in' do
    let(:user) { create(:user) }

    before do
      login_as user, scope: :user
    end

    it 'will not present videos that have tags' do
      create(:video, title: 'Tagged Video', tags: %w[hello world])
      visit dashboard_pending_tags_path
      expect(page).not_to have_text 'Tagged Video'
    end

    it 'allows to set tags for videos without tags' do
      create(:video, title: 'Untagged Video', tags: [])
      visit dashboard_pending_tags_path
      expect(page).to have_text 'Untagged Video'
    end

    it 'updates tags for modified videos' do
      video = create(:video, title: 'Untagged Video', tags: [])
      visit dashboard_pending_tags_path

      within '#pending_tags' do
        fill_in 'Etiquetas para Untagged Video', with: 'hello world how are you'
        click_button 'Aplicar'
      end

      expect(video.reload.tags).to match_array %w[hello world how are you]
    end
  end
end
