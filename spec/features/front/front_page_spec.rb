require 'rails_helper'

RSpec.feature "Front page", type: :feature do
  it "is success" do
    visit root_path
    expect(page.status_code).to be 200
  end

  it "presents the project" do
    visit root_path
    expect(page).to have_text "¿Qué es makigas?"
  end

  context "can show opinions" do
    it "with link" do
      @opinion = FactoryGirl.create(:opinion)
      visit root_path
      expect(page).to have_link @opinion.from, href: @opinion.url
    end

    it "without link" do
      @opinion = FactoryGirl.create(:opinion, url: nil)
      visit root_path
      expect(page).to have_text @opinion.from
    end

    it "with description" do
      @opinion = FactoryGirl.create(:opinion)
      visit root_path
      expect(page).to have_text @opinion.message
    end
  end

  it "navigates to topics" do
    visit root_path
    expect(page).to have_link "Explora las temáticas", href: topics_path
  end

  context "when there are videos" do
    before(:each) {
      @video = FactoryGirl.create(:video)
    }

    it "shows the video thumbnail" do
      visit root_path
      within '.recent-videos' do
        expect(page).to have_css "img[src='https://i1.ytimg.com/vi/#{@video.youtube_id}/mqdefault.jpg']"
      end
    end

    it "links to the video" do
      visit root_path
      within '.recent-videos' do
        expect(page).to have_link @video.title, href: playlist_video_path(@video, playlist_id: @video.playlist)
      end
    end

    it "doesn't show videos hidden from front" do
      @hidden = FactoryGirl.create(:video, title: 'Hidden', youtube_id: 'AABBCC', unfeatured: true)
      visit root_path
      within '.recent-videos' do
        expect(page).to have_link @video.title
        expect(page).not_to have_link @hidden.title
      end
    end
  end
end
