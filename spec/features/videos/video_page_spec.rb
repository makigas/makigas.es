# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Video page', type: :feature do
  let(:video) { create(:video, duration: 133) }

  it 'there is information about the video' do
    visit_video video

    aggregate_failures do
      expect(page).to have_text video.title
      expect(page).to have_content video.description
      expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
    end
  end

  it 'the page is indexable' do
    visit_video video
    expect(page).not_to have_css 'meta[name="robots"][content="noindex"]', visible: :hidden
  end

  it 'there is a player embedded in' do
    visit_video video

    expect(page).to have_css "iframe[src*='www.youtube-nocookie.com/embed/#{video.youtube_id}']"
  end

  it 'there is a playlist card' do
    visit_video video

    aggregate_failures do
      within("//div[@class='video-information']") do
        expect(page).to have_content video.playlist.title
        expect(page).to have_css "img[src*='#{video.playlist.thumbnail.url(:small)}']"
      end
    end
  end

  context 'when a topic is assigned' do
    let(:topic) { create(:topic) }
    let(:playlist) { create(:playlist, topic: topic) }
    let(:video) { create(:video, playlist: playlist) }

    it 'there is a topic card' do
      visit_video video

      aggregate_failures do
        within("//div[@class='video-information']") do
          expect(page).to have_content topic.title
          expect(page).to have_content topic.description
          expect(page).to have_css "img[src*='#{topic.thumbnail.url(:small)}']"
        end
      end
    end
  end

  describe 'when the video has show notes' do
    let(:topic) { create(:topic) }
    let(:playlist) { create(:playlist, topic: topic) }
    let(:show_note) { build(:show_note, documentable: nil) }
    let(:video) { create(:video, playlist: playlist, show_note: show_note) }

    it 'presents the show notes' do
      visit_video video

      within("//div[@class='video-information']") do
        expect(page).to have_content show_note.content
      end
    end
  end

  context 'when the video is scheduled but not private' do
    let(:video) { create(:video, published_at: 2.days.from_now) }

    it 'there is information about the video' do
      visit_video video

      aggregate_failures do
        expect(page).to have_text video.title
        expect(page).to have_content video.description
        expect(page).to have_link video.playlist.title, href: playlist_path(video.playlist)
      end
    end

    it 'the page is marked as scheduled' do
      visit_video video
      expect(page).to have_text 'Esto es una vista previa de un vídeo que próximamente estará en YouTube (imagino).'
    end

    it 'the page is NOT indexable' do
      visit_video video
      expect(page).to have_css 'meta[name="robots"][content="noindex"]', visible: :hidden
    end

    it 'there is a player embedded in' do
      visit_video video

      expect(page).to have_css "iframe[src*='www.youtube-nocookie.com/embed/#{video.youtube_id}']"
    end

    it 'there is a playlist card' do
      visit_video video

      aggregate_failures do
        within("//div[@class='video-information']") do
          expect(page).to have_content video.playlist.title
          expect(page).to have_css "img[src*='#{video.playlist.thumbnail.url(:small)}']"
        end
      end
    end

    context 'when a topic is assigned' do
      let(:topic) { create(:topic) }
      let(:playlist) { create(:playlist, topic: topic) }
      let(:video) { create(:video, playlist: playlist) }

      it 'there is a topic card' do
        visit_video video

        aggregate_failures do
          within("//div[@class='video-information']") do
            expect(page).to have_content topic.title
            expect(page).to have_content topic.description
            expect(page).to have_css "img[src*='#{topic.thumbnail.url(:small)}']"
          end
        end
      end
    end
  end

  context 'when the video is scheduled and private' do
    let(:video) { create(:video, published_at: 2.days.from_now, private: true) }

    it 'the page requires authorization' do
      visit_video video
      expect(page).to have_no_current_path playlist_video_path(video, playlist_id: video.playlist)
    end

    context 'when the user is logged in' do
      let(:user) { create(:user) }

      before do
        login_as user, scope: :user
      end

      it 'the page is not indexable' do
        visit_video video
        expect(page).to have_css 'meta[name="robots"][content="noindex"]', visible: :hidden
      end
    end
  end
end

private

def visit_video(video)
  visit playlist_video_path(video, playlist_id: video.playlist)
end
