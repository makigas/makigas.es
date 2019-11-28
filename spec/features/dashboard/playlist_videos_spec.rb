require 'rails_helper'

RSpec.feature "Dashboard playlist videos", type: :feature do
  before { Capybara.default_host = "http://dashboard.example.com" }
  after { Capybara.default_host = "http://www.example.com" }

  before(:each) {
    @playlist = FactoryBot.create(:playlist)
    @videos = [
      FactoryBot.create(:video, playlist: @playlist, title: 'Primero', position: 1, youtube_id: '1'),
      FactoryBot.create(:video, playlist: @playlist, title: 'Segundo', position: 2, youtube_id: '2')
    ]
  }

  context "when not logged in" do
    it "should not be success" do
      visit videos_dashboard_playlist_path(@playlist)
      expect(page.current_path).not_to eq videos_dashboard_playlist_path(@playlist)
    end
  end

  context "when logged in" do
    before(:each) {
      @user = FactoryBot.create(:user)
      login_as @user, scope: :user
    }

    scenario "user can access this page via dashboard video page" do
      visit dashboard_playlists_path
      click_link @playlist.title
      within(".dashboard-page") do
        click_link "Vídeos"
      end
      expect(page.current_path).to eq videos_dashboard_playlist_path(@playlist)
    end

    scenario "user can access this page via video count link" do
      visit dashboard_playlists_path
      within(:xpath, "//tr[.//td//a[text() = '#{@playlist.title}']]") do
        click_link @playlist.videos.count.to_s
      end
      expect(page.current_path).to eq videos_dashboard_playlist_path(@playlist)
    end

    scenario "this page lists videos in the right order" do
      visit videos_dashboard_playlist_path(@playlist)
      within(".dashboard-page tbody") do
        expect(page).to have_xpath("//tr[1]/td[2]/a", text: @videos[0].title)
        expect(page).to have_xpath("//tr[2]/td[2]/a", text: @videos[1].title)
      end
    end

    scenario "user can move a video down" do
      visit videos_dashboard_playlist_path(@playlist)
      within(:xpath, "//tr[.//td//a[text() = '#{@videos[0].title}']]") do
        click_button "Bajar"
      end
      within(".dashboard-page tbody") do
        expect(page).to have_xpath("//tr[1]/td[2]/a", text: @videos[1].title)
        expect(page).to have_xpath("//tr[2]/td[2]/a", text: @videos[0].title)
      end
    end

    scenario "user can move a video down" do
      visit videos_dashboard_playlist_path(@playlist)
      within(:xpath, "//tr[.//td//a[text() = '#{@videos[1].title}']]") do
        click_button "Subir"
      end
      within(".dashboard-page tbody") do
        expect(page).to have_xpath("//tr[1]/td[2]/a", text: @videos[1].title)
        expect(page).to have_xpath("//tr[2]/td[2]/a", text: @videos[0].title)
      end
    end

    scenario "moving first video up changes nothing" do
      visit videos_dashboard_playlist_path(@playlist)
      within(:xpath, "//tr[.//td//a[text() = '#{@videos[0].title}']]") do
        click_button "Subir"
      end
      within(".dashboard-page tbody") do
        expect(page).to have_xpath("//tr[1]/td[2]/a", text: @videos[0].title)
        expect(page).to have_xpath("//tr[2]/td[2]/a", text: @videos[1].title)
      end
    end

    scenario "moving last video down changes nothing" do
      visit videos_dashboard_playlist_path(@playlist)
      within(:xpath, "//tr[.//td//a[text() = '#{@videos[1].title}']]") do
        click_button "Bajar"
      end
      within(".dashboard-page tbody") do
        expect(page).to have_xpath("//tr[1]/td[2]/a", text: @videos[0].title)
        expect(page).to have_xpath("//tr[2]/td[2]/a", text: @videos[1].title)
      end
    end
  end
end
