# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard videos', :js do
  before do
    Capybara.app_host = 'http://dashboard.lvh.me:9080'
    Capybara.server_port = 9080
  end

  after do
    Capybara.app_host = nil
    Capybara.server_port = nil
  end

  context 'when not logged in' do
    it 'is not success' do
      visit dashboard_videos_path
      expect(page).not_to have_current_path dashboard_playlists_path
    end
  end

  context 'when logged in' do
    let(:user) { create(:user) }
    let!(:video) { create(:video) }
    let!(:playlist) { create(:playlist) }

    before do
      login_as user, scope: :user
    end

    it 'user can list videos' do
      visit dashboard_videos_path
      expect(page).to have_link video.title
    end

    it 'user can create videos' do
      visit dashboard_videos_path
      click_link 'Nuevo Vídeo'
      fill_in 'Título', with: 'My video title'
      fill_in 'Descripción', with: 'This is my newest and coolest video'
      fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
      fill_in 'duration-hours', with: '1'
      fill_in 'duration-minutes', with: '5'
      fill_in 'duration-seconds', with: '40'
      fill_in 'Etiquetas', with: 'javascript ruby go'
      select playlist.title, from: 'Lista de reproducción'
      click_button 'Crear Vídeo'

      aggregate_failures do
        expect(page).to have_text 'Vídeo creado correctamente'
        expect(page).to have_text 'My video title'
        expect(page).to have_text 'go javascript ruby'
        expect(page).to have_text '1:05:40'
      end
    end

    it 'user can create multiple videos in a row', :js do
      visit dashboard_videos_path
      click_link 'Nuevo Vídeo'
      fill_in 'Título', with: 'My video title'
      fill_in 'Descripción', with: 'This is my newest and coolest video'
      fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
      fill_in 'duration-hours', with: '1'
      fill_in 'duration-minutes', with: '5'
      fill_in 'duration-seconds', with: '40'
      select playlist.title, from: 'Lista de reproducción'
      click_button 'Guardar y crear otro'

      aggregate_failures do
        expect(page).to have_text 'Vídeo creado correctamente'
        expect(page).to have_text 'Nuevo vídeo'
      end
    end

    it 'user cannot create videos with invalid data' do
      playlist = create(:playlist)
      visit dashboard_videos_path
      click_link 'Nuevo Vídeo'
      fill_in 'Descripción', with: 'This is my newest and coolest video'
      fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
      select playlist.title, from: 'Lista de reproducción'
      click_button 'Crear Vídeo'

      expect(page).not_to have_text 'Vídeo creado correctamente'
    end

    it 'user cannot create videos without setting a playlist' do
      visit dashboard_videos_path
      click_link 'Nuevo Vídeo'
      fill_in 'Título', with: 'My video title'
      fill_in 'Descripción', with: 'This is my newest and coolest video'
      fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
      fill_in 'duration-minutes', with: '3'
      fill_in 'duration-seconds', with: '32'
      click_button 'Crear Vídeo'

      expect(page).not_to have_text 'Vídeo creado correctamente'
    end

    it 'user can edit videos' do
      visit dashboard_videos_path
      within(:xpath, "//tr[.//a[text() = '#{video.title}']]") do
        click_link 'Editar'
      end
      fill_in 'Título', with: 'My new video'
      click_button 'Actualizar Vídeo'

      expect(page).to have_text 'Vídeo actualizado correctamente'
    end

    it 'user can destroy videos' do
      visit dashboard_videos_path
      within(:xpath, "//tr[.//a[text() = '#{video.title}']]") do
        page.accept_confirm do
          click_button 'Destruir'
        end
      end

      aggregate_failures do
        expect(page).to have_text 'Vídeo destruido correctamente'
        expect(page).not_to have_link 'My cool video'
      end
    end
  end
end
