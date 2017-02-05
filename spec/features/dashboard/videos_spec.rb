require 'rails_helper'

RSpec.feature "Dashboard videos", type: :feature do
  context "when not logged in" do
    it "should not be success" do
      visit dashboard_videos_path
      expect(page.current_path).not_to eq dashboard_playlists_path
    end
  end

  context "when logged in" do
    before(:each) {
      @user = FactoryGirl.create(:user)
      login_as @user, scope: :user
    }

    scenario "user can list videos" do
      @video = FactoryGirl.create(:video)
      visit dashboard_videos_path
      expect(page).to have_link @video.title
    end

    scenario "user can create videos" do
      @playlist = FactoryGirl.create(:playlist)
      
      visit dashboard_videos_path
      expect {
        click_link 'Nuevo Vídeo'
        fill_in 'Título', with: 'My video title'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        # TODO: Should test the actual interaction with duration controls.
        # (They require JavaScript and I'll prefer to finish this test suite
        # before adding extra dependencies that could break existing tests)
        find(:xpath, "//input[@id='video_duration']", visible: false).set '212'
        select @playlist.title, from: 'Lista de reproducción'
        click_button 'Crear Vídeo'
      }.to change { Video.count }.by 1

      expect(page).to have_text 'Vídeo creado correctamente'
      expect(@playlist.videos.count).to eq 1
    end

    scenario "user cannot create videos with invalid data" do
      @playlist = FactoryGirl.create(:playlist)
      visit dashboard_videos_path
      expect {
        click_link 'Nuevo Vídeo'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        select @playlist.title, from: 'Lista de reproducción'
        click_button 'Crear Vídeo'
      }.not_to change { Video.count }
      expect(page).not_to have_text 'Vídeo creado correctamente'
    end

    scenario "user cannot create videos without setting a playlist" do
      visit dashboard_videos_path
      expect {
        click_link 'Nuevo Vídeo'
        fill_in 'Título', with: 'My video title'
        fill_in 'Descripción', with: 'This is my newest and coolest video'
        fill_in 'ID de YouTube', with: 'dQw4w9WgXcQ'
        # TODO: Should test the actual interaction with duration controls.
        # (They require JavaScript and I'll prefer to finish this test suite
        # before adding extra dependencies that could break existing tests)
        find(:xpath, "//input[@id='video_duration']", visible: false).set '212'
        click_button 'Crear Vídeo'
      }.not_to change { Video.count }
      expect(page).not_to have_text 'Vídeo creado correctamente'
    end

    scenario "user can edit videos" do
      @video = FactoryGirl.create(:video, title: 'My old video')

      visit dashboard_videos_path
      within(:xpath, "//tr[.//a[text() = 'My old video']]") do
        click_link 'Editar'
      end
      fill_in 'Título', with: 'My new video'
      click_button 'Actualizar Vídeo'

      expect(page).to have_text 'Vídeo actualizado correctamente'
    end

    scenario "user can destroy videos" do
      @video = FactoryGirl.create(:video, title: 'My cool video')

      visit dashboard_videos_path
      expect {
        within(:xpath, "//tr[.//a[text() = '#{@video.title}']]") do
          click_button 'Destruir'
        end
      }.to change { Video.count }.by -1

      expect(page).to have_text 'Vídeo destruido correctamente'
      expect(page).not_to have_link 'My cool video'
    end
  end
end