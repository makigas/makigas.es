# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Dashboard playlists', type: :feature do
  before { Capybara.default_host = 'http://dashboard.example.com' }

  after { Capybara.default_host = 'http://www.example.com' }

  context 'when not logged in' do
    it 'is not success' do
      visit dashboard_playlists_path
      expect(page).to have_no_current_path dashboard_playlists_path
    end
  end

  context 'when logged in' do
    before do
      @user = FactoryBot.create(:user)
      login_as @user, scope: :user
    end

    scenario 'user can list the playlists' do
      @playlist = FactoryBot.create(:playlist)
      @video = FactoryBot.create(:video, playlist: @playlist)

      visit dashboard_playlists_path
      expect(page).to have_link @playlist.title, href: dashboard_playlist_path(@playlist)
      within(:xpath, "//tr[.//td//a[text() = '#{@playlist.title}']]") do
        expect(page).to have_xpath '//td', text: @playlist.videos.count
      end
    end

    scenario 'user can create playlists' do
      visit dashboard_playlists_path
      click_link 'Nueva Lista'
      expect do
        fill_in 'Título', with: 'My Playlist'
        fill_in 'Descripción', with: 'This is a playlist part of my site'
        fill_in 'ID de YouTube', with: 'AABBCCDDEEFF'
        attach_file 'Miniatura', Rails.root.join('spec/fixtures/playlist.png')
        attach_file 'Tarjeta', Rails.root.join('spec/fixtures/card.jpg')
        click_button 'Crear Lista de reproducción'
      end.to change(Playlist, :count).by 1
      expect(page).to have_text 'Lista creada correctamente'
    end

    scenario 'user can attach a playlist to a topic' do
      @topic = FactoryBot.create(:topic)

      visit dashboard_playlists_path
      click_link 'Nueva Lista'
      fill_in 'Título', with: 'My Playlist'
      fill_in 'Descripción', with: 'This is a playlist part of my site'
      fill_in 'ID de YouTube', with: 'AABBCCDDEEFF'
      attach_file 'Miniatura', Rails.root.join('spec/fixtures/playlist.png')
      attach_file 'Tarjeta', Rails.root.join('spec/fixtures/card.jpg')
      select @topic.title, from: 'Tema'
      click_button 'Crear Lista de reproducción'

      expect(page).to have_text 'Lista creada correctamente'
      expect(@topic.playlists.count).to eq 1
    end

    scenario 'user can edit a playlist' do
      @playlist = FactoryBot.create(:playlist, title: 'My old title')

      visit dashboard_playlists_path
      within(:xpath, "//tr[.//td//a[text() = 'My old title']]") do
        click_link 'Editar'
      end

      fill_in 'Título', with: 'My new title'
      click_button 'Actualizar Lista de reproducción'

      expect(page).to have_text 'Lista actualizada correctamente'
      @playlist.reload
      expect(@playlist.title).to eq 'My new title'
    end

    scenario 'user can destroy a playlist' do
      @playlist = FactoryBot.create(:playlist)

      visit dashboard_playlists_path
      expect do
        within(:xpath, "//tr[.//td//a[text() = '#{@playlist.title}']]") do
          click_button 'Destruir'
        end
      end.to change(Playlist, :count).by(-1)

      expect(page).to have_text 'Lista eliminada correctamente'
    end
  end
end
