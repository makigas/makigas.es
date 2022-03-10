# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos search', type: :feature do
  let(:service) { class_double('VideoSearch').as_stubbed_const }

  describe 'searching by length' do
    let!(:short) { create(:video, duration: 200, title: 'Short', youtube_id: '1') }
    let!(:medium) { create(:video, duration: 600, title: 'Medium', youtube_id: '2') }
    let!(:long) { create(:video, duration: 1200, title: 'Long', youtube_id: '3') }

    after { Video.clear_index! }

    it 'can search for short length videos' do
      # Tune the search service mock for this purpose.
      inst = instance_double('VideoSearch', videos: Video.where('duration < 300').page(1).per(10))
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      choose 'Cortos'
      click_button 'Aplicar filtros'

      aggregate_failures do
        expect(service).to have_received(:new).with('', hash_including(filters: hash_including(length: 'short')))
        expect(page).to have_link short.title, href: video_path(short)
        expect(page).not_to have_link medium.title, href: video_path(medium)
        expect(page).not_to have_link long.title, href: video_path(long)
      end
    end

    it 'can search for medium length videos' do
      # Tune the search service mock for this purpose.
      videos = Video.where('duration > 300').where('duration <= 900').page(1).per(10)
      inst = instance_double('VideoSearch', videos: videos)
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      choose 'Medios'
      click_button 'Aplicar filtros'

      aggregate_failures do
        expect(service).to have_received(:new).with('', hash_including(filters: hash_including(length: 'medium')))
        expect(page).not_to have_link short.title, href: video_path(short)
        expect(page).to have_link medium.title, href: video_path(medium)
        expect(page).not_to have_link long.title, href: video_path(long)
      end
    end

    it 'can search for long length videos' do
      # Tune the search service mock for this purpose.
      inst = instance_double('VideoSearch', videos: Video.where('duration > 900').page(1).per(10))
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      choose 'Largos'
      click_button 'Aplicar filtros'

      aggregate_failures do
        expect(service).to have_received(:new).with('', hash_including(filters: hash_including(length: 'long')))
        expect(page).not_to have_link short.title, href: video_path(short)
        expect(page).not_to have_link medium.title, href: video_path(medium)
        expect(page).to have_link long.title, href: video_path(long)
      end
    end
  end

  describe 'searching by topic' do
    let!(:video1) do
      create(:video, title: 'First', youtube_id: 'A').tap do |video|
        video.playlist.topic.update(title: 'First Topic', slug: 'first')
      end
    end

    let!(:video2) do
      create(:video, title: 'Second', youtube_id: 'B').tap do |video|
        video.playlist.topic.update(title: 'Second Topic', slug: 'second')
      end
    end

    it 'can search for videos in a topic' do
      # Tune the search service mock for this purpose.
      videos = Video.includes(playlist: :topic).where(topics: { title: 'First Topic' }).page(1).per(10)
      inst = instance_double('VideoSearch', videos: videos)
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      check 'First Topic'
      click_button 'Aplicar filtros'

      aggregate_failures do
        expect(service).to have_received(:new).with('', hash_including(filters: hash_including(topic: ['first'])))
        expect(page).to have_link video1.title, href: video_path(video1)
        expect(page).not_to have_link video2.title, href: video_path(video2)
      end
    end

    it 'can search for videos in multiple topics' do
      # Tune the search service mock for this purpose.
      videos = Video.includes(playlist: :topic)
                    .where(topics: { title: ['First Topic', 'Second Topic'] }).page(1).per(10)
      inst = instance_double('VideoSearch', videos: videos)
      allow(service).to receive(:new).and_return(inst)

      visit videos_path
      check 'First Topic'
      check 'Second Topic'
      click_button 'Aplicar filtros'

      aggregate_failures do
        filters = hash_including(topic: %w[first second])
        expect(service).to have_received(:new).with('', hash_including(filters: filters))
        expect(page).to have_link video1.title, href: video_path(video1)
        expect(page).to have_link video2.title, href: video_path(video2)
      end
    end
  end

  private

  def video_path(video)
    playlist_video_path(video, playlist_id: video.playlist)
  end
end
