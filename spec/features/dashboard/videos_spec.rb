require 'rails_helper'

RSpec.feature "Dashboard videos", type: :feature, js: true do
  before do
    Capybara.app_host = 'http://dashboard.lvh.me:9080'
    Capybara.server_port = 9080
  end

  after do
    Capybara.app_host = nil
    Capybara.server_port = nil
  end

  context "when not logged in" do
    it "is not success" do
      visit dashboard_videos_path
      expect(page).to have_no_current_path dashboard_playlists_path
    end
  end

  context "when logged in" do
    before do
      @user = FactoryBot.create(:user)
      login_as @user, scope: :user
    end

    scenario "user can list videos" do
      @video = FactoryBot.create(:video)
      visit dashboard_videos_path
      expect(page).to have_link @video.title
    end

    scenario "user can create videos" do
      @playlist = FactoryBot.create(:playlist)

      visit dashboard_videos_path
      expect do
        click_link 'Nuevo Vídeo'
        fill_in 'Título', with: 'My video title'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        fill_in 'duration_minutes', with: '3'
        fill_in 'duration_seconds', with: '32'
        select @playlist.title, from: 'Lista de reproducción'
        click_button 'Crear Vídeo'
      end.to change(Video, :count).by 1

      expect(page).to have_text 'Vídeo creado correctamente'
      expect(@playlist.videos.count).to eq 1
    end

    scenario "user can set the duration of a video" do
      @playlist = FactoryBot.create(:playlist)
      visit dashboard_videos_path

      click_link 'Nuevo Vídeo'
      fill_in 'Título', with: 'My video title'
      fill_in 'Descripción', with: 'This is a long video'
      fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
      select @playlist.title, from: 'Lista de reproducción'
      fill_in 'duration_hours', with: '1'
      fill_in 'duration_minutes', with: '5'
      fill_in 'duration_seconds', with: '40'
      click_button 'Crear Vídeo'

      expect(page).to have_text 'Vídeo creado correctamente'
      expect(page).to have_text '1:05:40'
    end

    scenario "user can create unfeatured videos" do
      @playlist = FactoryBot.create(:playlist)
      visit dashboard_videos_path

      expect do
        click_link 'Nuevo Vídeo'
        fill_in 'Título', with: 'My video title'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        fill_in 'duration_minutes', with: '3'
        fill_in 'duration_seconds', with: '32'
        select @playlist.title, from: 'Lista de reproducción'
        check 'video_unfeatured'
        click_button 'Crear Vídeo'
      end.to change(Video, :count).by 1

      # Test the video does not appear
      Capybara.app_host = "http://www.lvh.me:9080"
      visit root_path
      within '.recent-videos' do
        expect(page).not_to have_link 'My video title'
      end
    end

    scenario "user cannot create videos with invalid data" do
      @playlist = FactoryBot.create(:playlist)
      visit dashboard_videos_path
      expect do
        click_link 'Nuevo Vídeo'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        select @playlist.title, from: 'Lista de reproducción'
        click_button 'Crear Vídeo'
      end.not_to change(Video, :count)
      expect(page).not_to have_text 'Vídeo creado correctamente'
    end

    scenario "user cannot create videos without setting a playlist" do
      visit dashboard_videos_path
      expect do
        click_link 'Nuevo Vídeo'
        fill_in 'Título', with: 'My video title'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        fill_in 'duration_minutes', with: '3'
        fill_in 'duration_seconds', with: '32'
        click_button 'Crear Vídeo'
      end.not_to change(Video, :count)
      expect(page).not_to have_text 'Vídeo creado correctamente'
    end

    scenario "user can edit videos" do
      @video = FactoryBot.create(:video, title: 'My old video')

      visit dashboard_videos_path
      within(:xpath, "//tr[.//a[text() = 'My old video']]") do
        click_link 'Editar'
      end
      fill_in 'Título', with: 'My new video'
      click_button 'Actualizar Vídeo'

      expect(page).to have_text 'Vídeo actualizado correctamente'
    end

    scenario "user can destroy videos" do
      @video = FactoryBot.create(:video, title: 'My cool video')

      visit dashboard_videos_path
      expect do
        within(:xpath, "//tr[.//a[text() = '#{@video.title}']]") do
          click_button 'Destruir'
        end
      end.to change(Video, :count).by(-1)

      expect(page).to have_text 'Vídeo destruido correctamente'
      expect(page).not_to have_link 'My cool video'
    end
  end
end
