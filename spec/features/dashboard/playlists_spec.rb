# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard playlists' do
  let(:video) { create(:video) }
  let!(:playlist) { create(:playlist, videos: [video]) }
  let!(:topic) { create(:topic) }

  before { Capybara.default_host = 'http://dashboard.example.com' }

  after { Capybara.default_host = 'http://www.example.com' }

  context 'when not logged in' do
    it 'is not success' do
      visit dashboard_playlists_path
      expect(page).not_to have_current_path dashboard_playlists_path
    end
  end

  context 'when logged in' do
    let(:user) { create(:user) }

    before do
      login_as user, scope: :user
    end

    it 'user can list the playlists' do
      visit dashboard_playlists_path

      aggregate_failures do
        expect(page).to have_link playlist.title, href: dashboard_playlist_path(playlist)
        within(:xpath, "//tr[.//td//a[text() = '#{playlist.title}']]") do
          expect(page).to have_xpath '//td', text: playlist.videos.count
        end
      end
    end

    it 'user can create playlists' do
      visit dashboard_playlists_path
      click_link 'Nueva Lista'
      fill_in 'Título', with: 'My Playlist'
      fill_in 'Descripción', with: 'This is a playlist part of my site'
      fill_in 'ID de YouTube', with: 'AABBCCDDEEFF'
      attach_file 'Miniatura', Rails.root.join('spec/fixtures/playlist.png')
      attach_file 'Tarjeta', Rails.root.join('spec/fixtures/card.jpg')
      click_button 'Crear Lista de reproducción'

      aggregate_failures do
        expect(page).to have_text 'Lista creada correctamente'
        expect(page).to have_text 'My Playlist'
      end
    end

    it 'user can attach a playlist to a topic' do
      visit dashboard_playlists_path
      click_link 'Nueva Lista'
      fill_in 'Título', with: 'My Playlist'
      fill_in 'Descripción', with: 'This is a playlist part of my site'
      fill_in 'ID de YouTube', with: 'AABBCCDDEEFF'
      attach_file 'Miniatura', Rails.root.join('spec/fixtures/playlist.png')
      attach_file 'Tarjeta', Rails.root.join('spec/fixtures/card.jpg')
      select topic.title, from: 'Tema'
      click_button 'Crear Lista de reproducción'

      expect(topic.playlists.count).to eq 1
    end

    it 'user can edit a playlist' do
      visit dashboard_playlists_path
      within(:xpath, "//tr[.//td//a[text() = '#{playlist.title}']]") do
        click_link 'Editar'
      end

      fill_in 'Título', with: 'My new title'
      click_button 'Actualizar Lista de reproducción'

      aggregate_failures do
        expect(page).to have_text 'Lista actualizada correctamente'
        expect(page).to have_text 'My new title'
      end
    end

    it 'user can destroy a playlist' do
      visit dashboard_playlists_path
      within(:xpath, "//tr[.//td//a[text() = '#{playlist.title}']]") do
        click_button 'Destruir'
      end

      aggregate_failures do
        expect(page).to have_text 'Lista eliminada correctamente'
        expect(page).not_to have_link playlist.title
      end
    end
  end
end
