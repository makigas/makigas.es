require 'rails_helper'

RSpec.feature "Topics page", type: :feature do
  context "when there are no videos" do
    it "is success" do
      visit videos_path
      expect(page.status_code).to be 200
    end
  end

  context "when there are videos" do
    before(:each) { @video = FactoryGirl.create(:video, duration: 133) }

    it "is success" do
      visit videos_path
      expect(page.status_code).to be 200
    end

    it "shows the video title" do
      visit videos_path
      expect(page).to have_text @video.title
    end

    it "shows the video description" do
      visit videos_path
      expect(page).to have_text @video.description
    end

    it "shows the video duration" do
      visit videos_path
      expect(page).to have_text "Duración: 2:13"
    end

    it "shows the video playlist" do
      visit videos_path
      expect(page).to have_text "Serie: #{@video.playlist.title}"
    end

    it "links to the video" do
      visit videos_path
      expect(page).to have_link @video.title, href: playlist_video_path(@video, playlist_id: @video.playlist)
    end

    it "links to the playlist for this video" do
      visit videos_path
      expect(page).to have_link @video.playlist.title, href: playlist_path(@video.playlist)
    end
  end
end