# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard video', :js do
  let(:user) { create(:user) }
  let(:video) { create(:video) }

  before do
    Capybara.app_host = 'http://dashboard.lvh.me:9080'
    Capybara.server_port = 9080
    login_as user, scope: :user
  end

  after do
    Capybara.app_host = nil
    Capybara.server_port = nil
  end

  it 'can update the slug of a video' do
    video.update(title: 'An updated video', slug: 'original-slug')

    visit dashboard_playlist_video_path(video.slug, playlist_id: video.playlist.slug)
    find_by_id('slugModalOpen').click

    within '#slugModal' do
      fill_in 'Identificador', with: 'my-custom-slug'
      click_on 'Actualizar'
    end

    aggregate_failures do
      expect(video.reload.slug).to eq 'my-custom-slug'
      expect(page).to have_text 'Identificador del vídeo actualizado correctamente.'
    end
  end

  it 'can reset the slug of a video' do
    video.update(title: 'An updated video', slug: 'original-slug')

    visit dashboard_playlist_video_path(video.slug, playlist_id: video.playlist.slug)
    find_by_id('slugModalOpen').click

    within '#slugModal' do
      check 'Reestablecer al valor por defecto'
      click_on 'Actualizar'
    end

    aggregate_failures do
      expect(page).to have_text 'Identificador del vídeo actualizado correctamente.'
      expect(video.reload.slug).to eq 'an-updated-video'
    end
  end
end
