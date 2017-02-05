require 'rails_helper'

RSpec.feature "Playlists page", type: :feature do
  context "when there are no playlists" do
    it "is success" do
      visit playlists_path
      expect(page.status_code).to be 200
    end
  end
  
  context "when there are playlists" do
    before(:each) {
      @playlist = FactoryGirl.create(:playlist)
    }

    it "it is success" do
      visit playlists_path
      expect(page.status_code).to be 200
    end

    it "shows the playlists" do
      visit playlists_path
      expect(page).to have_text @playlist.title
    end

    it "has the playlist photo" do
      visit playlists_path
      expect(page).to have_css("img[src*='#{@playlist.thumbnail.url(:default)}']")
    end

    it "links to a playlist" do
      visit playlists_path
      expect(page).to have_link @playlist.title, href: playlist_path(@playlist)
    end

    context "when the playlist is empty" do
      it "counts the episodes" do
        visit playlists_path
        expect(page).to have_text "0 episodios"
      end
    end

    context "when the playlist has a video" do
      before(:each) {
        @video = FactoryGirl.create(:video, playlist: @playlist)
      }

      it "counts the episodes" do
        visit playlists_path
        expect(page).to have_text "1 episodio"
      end
    end

    context "when the playlist has two videos" do
      before(:each) {
        @video1 = FactoryGirl.create(:video, playlist: @playlist)
        @video2 = FactoryGirl.create(:video, playlist: @playlist, youtube_id: "#{@video1.youtube_id}A")
      }

      it "counts the episodes" do
        visit playlists_path
        expect(page).to have_text "#{@playlist.videos.count} episodios"
      end
    end
  end
end
