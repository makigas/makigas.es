# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard show notes', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:playlist) { create(:playlist) }
  let(:video) { create(:video, playlist: playlist) }

  let(:row) { "//tr[./td//text()[contains(., 'Notas del episodio')]]" }

  before do
    Capybara.app_host = 'http://dashboard.lvh.me:9080'
    Capybara.server_port = 9080
  end

  after do
    Capybara.app_host = nil
    Capybara.server_port = nil
  end

  describe 'for anonymous sessions' do
    let(:path) { dashboard_playlist_video_show_note_path(video, playlist_id: playlist.slug) }

    it 'is not possible to visit the show notes editor' do
      visit path
      expect(page).to have_no_current_path path
    end
  end

  describe 'for logged in sessions' do
    before { login_as user, scope: :user }

    describe 'when there is no show notes present for a video' do
      it 'says so if I visit the video page' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          expect(page).to have_text '(No existen notas del episodio)'
        end
      end

      it 'will allow me to create some show notes' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          click_link 'Editar'
        end
        fill_in 'Contenido', with: 'Estas son mis notas de episodio'
        click_button 'Crear Notas de episodio'
        within(:xpath, row) do
          expect(page).to have_text 'Estas son mis notas de episodio'
        end
      end

      it 'will not allow me to delete some show notes' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          expect(page).not_to have_link 'Destruir'
        end
      end
    end

    describe 'when there is some show notes present for a video' do
      before do
        create(:show_note, documentable: video,
                           content: 'Estas son mis notas de episodio')
      end

      it 'presents the show notes in the video page' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          expect(page).to have_text 'Estas son mis notas de episodio'
        end
      end

      it 'will allow me to edit some show notes' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          click_link 'Editar'
        end
        fill_in 'Contenido', with: 'Estas son las nuevas notas de episodio'
        click_button 'Actualizar Transcripción'
        within(:xpath, row) do
          expect(page).to have_text 'Estas son mis notas de episodio'
        end
      end

      it 'allows me to delete some show notes' do
        visit dashboard_playlist_video_path(video, playlist_id: playlist.slug)
        within(:xpath, row) do
          page.accept_confirm do
            click_button 'Destruir'
          end
        end

        within(:xpath, row) do
          expect(page).to have_text '(No existen notas del episodio)'
        end
      end
    end
  end
end
