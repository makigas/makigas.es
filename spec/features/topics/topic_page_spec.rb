require 'rails_helper'

RSpec.feature "Topic page", type: :feature do
  before(:each) {
    @topic = FactoryGirl.create(:topic)
  }

  context "visiting a topic page" do
    it "is success" do
      visit topic_path(@topic)
      expect(page.status_code).to be 200
    end

    it "shows the topic title" do
      visit topic_path(@topic)
      expect(page).to have_text @topic.title
    end

    it "shows the topic description" do
      visit topic_path(@topic)
      expect(page).to have_text @topic.description
    end

    it "shows the topic image" do
      visit topic_path(@topic)
      expect(page).to have_css "img[src*='#{@topic.thumbnail.url(:small)}']"
    end
  end

  context "when the topic has playlists" do
    before(:each) {
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
    }

    it "shows the playlist title" do
      visit topic_path(@topic)
      expect(page).to have_text @playlist.title
    end

    it "shows the playlist image" do
      visit topic_path(@topic)
      expect(page).to have_css "img[src*='#{@playlist.thumbnail.url(:default)}']"
    end

    it "links to the playlist" do
      visit topic_path(@topic)
      expect(page).to have_css "a[href*='#{playlist_path(@playlist)}']"
    end
  end
end
