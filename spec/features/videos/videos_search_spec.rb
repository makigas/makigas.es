# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos search' do
  let(:service) { class_double(VideoSearch).as_stubbed_const }

  describe 'searching by length' do
    let!(:short) { create(:video, duration: 200, title: 'Short', youtube_id: '1') }
    let!(:medium) { create(:video, duration: 600, title: 'Medium', youtube_id: '2') }
    let!(:long) { create(:video, duration: 1200, title: 'Long', youtube_id: '3') }

    it 'can search for short length videos' do
      # Tune the search service mock for this purpose.
      inst = instance_double(VideoSearch, videos: Video.where('duration < 300').page(1).per(10),
                                          search_request: build(:search_request))
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      within '.Layout__sidebar' do
        click_on 'Cortos'
      end

      aggregate_failures do
        expect(service).to have_received(:new).with(nil, hash_including(filters: hash_including(length: 'short')))
        expect(page).to have_link short.title, href: video_path(short)
        expect(page).to have_no_link medium.title, href: video_path(medium)
        expect(page).to have_no_link long.title, href: video_path(long)
      end
    end

    it 'can search for medium length videos' do
      # Tune the search service mock for this purpose.
      videos = Video.where('duration > 300').where('duration <= 900').page(1).per(10)
      inst = instance_double(VideoSearch, videos:, search_request: build(:search_request))
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      within '.Layout__sidebar' do
        click_on 'Medios'
      end

      aggregate_failures do
        expect(service).to have_received(:new).with(nil, hash_including(filters: hash_including(length: 'medium')))
        expect(page).to have_no_link short.title, href: video_path(short)
        expect(page).to have_link medium.title, href: video_path(medium)
        expect(page).to have_no_link long.title, href: video_path(long)
      end
    end

    it 'can search for long length videos' do
      # Tune the search service mock for this purpose.
      inst = instance_double(VideoSearch, videos: Video.where('duration > 900').page(1).per(10),
                                          search_request: build(:search_request))
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      within '.Layout__sidebar' do
        click_on 'Largos'
      end

      aggregate_failures do
        expect(service).to have_received(:new).with(nil, hash_including(filters: hash_including(length: 'long')))
        expect(page).to have_no_link short.title, href: video_path(short)
        expect(page).to have_no_link medium.title, href: video_path(medium)
        expect(page).to have_link long.title, href: video_path(long)
      end
    end

    it 'saves the request history if the user is not logged in' do
      # Tune the search service mock for this purpose.
      inst = instance_double(VideoSearch, videos: Video.where('duration > 900').page(1).per(10),
                                          search_request: build(:search_request))
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      within '.Layout__sidebar' do
        click_on 'Largos'
      end

      expect(SearchRequest.count).to eq 1
    end

    it 'does not save the request history if the user is logged in' do
      # Tune the search service mock for this purpose.
      inst = instance_double(VideoSearch, videos: Video.where('duration > 900').page(1).per(10),
                                          search_request: build(:search_request))
      allow(service).to receive(:new).and_return(inst)

      login_as create(:user), scope: :user
      visit videos_path
      within '.Layout__sidebar' do
        click_on 'Largos'
      end

      expect(SearchRequest.count).to eq 0
    end
  end

  private

  def video_path(video)
    playlist_video_path(video, playlist_id: video.playlist)
  end
end
