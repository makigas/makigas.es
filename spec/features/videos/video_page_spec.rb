require 'rails_helper'

RSpec.feature "Video page", type: :feature do
  before(:each) { @video = FactoryGirl.create(:video, duration: 133) }

  it "is success" do
    visit_video @video
    expect(page.status_code). to be 200
  end

  it "shows the video title" do
    visit_video @video
    expect(page).to have_text @video.title
  end

  it "links to the playlist" do
    visit_video @video
    expect(page).to have_link @video.playlist.title, href: playlist_path(@video.playlist)
  end

  it "has an embed to YouTube" do
    visit_video @video
    expect(page).to have_css "iframe[src*='www.youtube.com/embed/#{@video.youtube_id}']"
  end

  it "shows the video description" do
    visit_video @video
    expect(page).to have_content @video.description
  end

  it "links to the playlist in a box" do
    visit_video @video
    within("//div[@class='video-information']") do
      expect(page).to have_content @video.playlist.title
      expect(page).to have_css "img[src*='#{@video.playlist.thumbnail.url(:small)}']"
    end
  end

  context "when there is a topic for this playlist" do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @video.playlist.update_attributes(topic: @topic)
    end

    it "links to the topic in a box" do
      visit_video @video
      within("//div[@class='video-information']") do
        expect(page).to have_content @topic.title
        expect(page).to have_content @topic.description
        expect(page).to have_css "img[src*='#{@topic.thumbnail.url(:small)}']"
      end
    end
  end
end

private

def visit_video(video)
  visit playlist_video_path(video, playlist_id: video.playlist)
end