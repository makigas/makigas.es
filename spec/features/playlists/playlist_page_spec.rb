require 'rails_helper'

RSpec.feature "Playlist page", type: :feature do
  before(:each) { @playlist = FactoryGirl.create(:playlist) }

  context "visiting a playlist" do
    it "is success" do
      visit playlist_path(@playlist)
      expect(page.status_code).to eq 200
    end

    it "shows playlist title" do
      visit playlist_path(@playlist)
      expect(page).to have_text @playlist.title
    end

    it "shows playlist description" do
      visit playlist_path(@playlist)
      expect(page).to have_text @playlist.description
    end

    it "shows playlist image" do
      visit playlist_path(@playlist)
      expect(page).to have_css "img[src*='#{@playlist.thumbnail.url(:small)}']"
    end

    context "when the playlist is populated" do
      before(:each) { @video = FactoryGirl.create(:video, playlist: @playlist, duration: 133) }

      it "shows the video index and title" do
        visit playlist_path(@playlist)
        expect(page).to have_text "#{@video.position}. #{@video.title}"
      end

      it "shows the video description" do
        visit playlist_path(@playlist)
        expect(page).to have_text @playlist.description
      end

      it "shows the video duration" do
        visit playlist_path(@playlist)
        expect(page).to have_text "2:13"
      end

      it "links to the video page" do
        visit playlist_path(@playlist)
        expect(page).to have_css "a[href*='#{playlist_video_path(@video, playlist_id: @playlist)}']"
      end
    end
  end
end
