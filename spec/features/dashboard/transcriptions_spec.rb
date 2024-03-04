# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard transcriptions', :js do
  let(:user) { create(:user) }
  let(:playlist) { create(:playlist) }
  let(:video) { create(:video, playlist:) }

  let(:row) { "//tr[./td//text()[contains(., 'Transcripción')]]" }

  before do
    Capybara.app_host = 'http://dashboard.lvh.me:9080'
    Capybara.server_port = 9080
  end

  after do
    Capybara.app_host = nil
    Capybara.server_port = nil
  end

  describe 'for anonymous sessions' do
    let(:path) { dashboard_playlist_video_transcription_path(video, playlist_id: playlist.slug) }

    it 'is not possible to visit the transcription editor' do
      visit path
      expect(page).to have_no_current_path path
    end
  end

  describe 'for logged in sessions' do
    before { login_as user, scope: :user }

    describe 'when there is no transcription present for a video' do
      it 'says so if I visit the video page' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          expect(page).to have_text '(Transcripción no existente)'
        end
      end

      it 'allows me to create a transcription' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          click_on 'Editar'
        end
        fill_in 'Contenido', with: 'Este es el texto de mi vídeo'
        click_on 'Crear Transcripción'
        within(:xpath, row) do
          expect(page).to have_text 'Este es el texto de mi vídeo'
        end
      end

      it 'does not allow me to delete a transcription' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          expect(page).to have_no_link 'Destruir'
        end
      end
    end

    describe 'when there is a transcription present for a video' do
      before do
        create(:transcription, documentable: video,
                               content: 'Este es mi nuevo vídeo')
      end

      it 'presents the transcription in the video page' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          expect(page).to have_text 'Este es mi nuevo vídeo'
        end
      end

      it 'allows me to edit a transcription' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          click_on 'Editar'
        end
        fill_in 'Contenido', with: 'Este es el texto de mi vídeo'
        click_on 'Actualizar Transcripción'
        within(:xpath, row) do
          expect(page).to have_text 'Este es el texto de mi vídeo'
        end
      end

      it 'allows me to delete a transcription' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          page.accept_confirm do
            click_on 'Destruir'
          end
        end

        within(:xpath, row) do
          expect(page).to have_text '(Transcripción no existente)'
        end
      end
    end
  end
end
