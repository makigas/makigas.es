require 'rails_helper'

RSpec.feature 'Video page', type: :feature do
  before { @video = FactoryBot.create(:video, duration: 133) }

  scenario 'there is information about the video' do
    visit_video @video
    expect(page).to have_text @video.title
    expect(page).to have_content @video.description
    expect(page).to have_link @video.playlist.title, href: playlist_path(@video.playlist)
  end

  scenario 'the page is indexable' do
    visit_video @video
    expect(page).not_to have_css 'meta[name="robots"][content="noindex"]', visible: false
  end

  scenario 'there is a player embedded in' do
    visit_video @video

    expect(page).to have_css "iframe[src*='www.youtube-nocookie.com/embed/#{@video.youtube_id}']"
  end

  scenario 'there is a playlist card' do
    visit_video @video
    within("//div[@class='video-information']") do
      expect(page).to have_content @video.playlist.title
      expect(page).to have_css "img[src*='#{@video.playlist.thumbnail.url(:small)}']"
    end
  end

  context 'when a topic is assigned' do
    before do
      @topic = FactoryBot.create(:topic)
      @video.playlist.update(topic: @topic)
    end

    scenario 'there is a topic card' do
      visit_video @video
      within("//div[@class='video-information']") do
        expect(page).to have_content @topic.title
        expect(page).to have_content @topic.description
        expect(page).to have_css "img[src*='#{@topic.thumbnail.url(:small)}']"
      end
    end
  end

  context 'when the video is scheduled but not private' do
    before { @video.update(published_at: 2.days.from_now) }

    scenario 'there is information about the video' do
      visit_video @video
      expect(page).to have_text @video.title
      expect(page).to have_content @video.description
      expect(page).to have_link @video.playlist.title, href: playlist_path(@video.playlist)
    end

    scenario 'the page is marked as scheduled' do
      visit_video @video
      expect(page).to have_text 'Esto es una vista previa de un vídeo que próximamente estará en YouTube (imagino).'
    end

    scenario 'the page is NOT indexable' do
      visit_video @video
      expect(page).to have_css 'meta[name="robots"][content="noindex"]', visible: false
    end

    scenario 'there is a player embedded in' do
      visit_video @video

      expect(page).to have_css "iframe[src*='www.youtube-nocookie.com/embed/#{@video.youtube_id}']"
    end

    scenario 'there is a playlist card' do
      visit_video @video
      within("//div[@class='video-information']") do
        expect(page).to have_content @video.playlist.title
        expect(page).to have_css "img[src*='#{@video.playlist.thumbnail.url(:small)}']"
      end
    end

    context 'when a topic is assigned' do
      before do
        @topic = FactoryBot.create(:topic)
        @video.playlist.update(topic: @topic)
      end

      scenario 'there is a topic card' do
        visit_video @video
        within("//div[@class='video-information']") do
          expect(page).to have_content @topic.title
          expect(page).to have_content @topic.description
          expect(page).to have_css "img[src*='#{@topic.thumbnail.url(:small)}']"
        end
      end
    end
  end

  context 'when the video is scheduled and private' do
    before { @video.update(published_at: 2.days.from_now, private: true) }

    scenario 'the page requires authorization' do
      visit_video @video
      expect(page).to have_no_current_path playlist_video_path(@video, playlist_id: @video.playlist)
    end

    context 'when the user is logged in' do
      before do
        @user = FactoryBot.create(:user)
        login_as @user, scope: :user
      end

      scenario 'the page is not indexable' do
        visit_video @video
        expect(page).to have_css 'meta[name="robots"][content="noindex"]', visible: false
      end
    end
  end
end

private

def visit_video(video)
  visit playlist_video_path(video, playlist_id: video.playlist)
end
