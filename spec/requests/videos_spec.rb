# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos' do
  describe 'when an old video slug is used' do
    subject { response }

    let(:video) do
      create(:video, title: 'My video').tap do |video|
        video.update(title: 'Another video', slug: nil)
      end
    end

    describe 'when the video is accessed by the new slug' do
      before { get "/series/#{video.playlist.slug}/another-video" }

      it { is_expected.to have_http_status(:ok) }
    end

    describe 'when the video is accessed by the old slug' do
      before { get "/series/#{video.playlist.slug}/my-video" }

      it { is_expected.to have_http_status(:moved_permanently) }
      it { is_expected.to redirect_to "/series/#{video.playlist.slug}/another-video" }
    end
  end

  describe 'when an old playlist slug is used' do
    subject { response }

    let(:old_playlist) { create(:playlist) }
    let(:new_playlist) { create(:playlist) }
    let(:old_canonical) { "/series/#{old_playlist.slug}/#{video.slug}" }
    let(:new_canonical) { "/series/#{new_playlist.slug}/#{video.slug}" }

    let(:video) do
      create(:video, playlist: old_playlist).tap do |video|
        video.update(playlist: new_playlist)
      end
    end

    describe 'when accessing via the new playlist' do
      before { get new_canonical }

      it { is_expected.to have_http_status(:ok) }
    end

    describe 'when accessing via the old playlist' do
      before { get old_canonical }

      it { is_expected.to have_http_status(:moved_permanently) }
      it { is_expected.to redirect_to new_canonical }
    end
  end

  describe 'when an old video and playlist slug are used' do
    let(:old_playlist) { create(:playlist, title: 'One playlist') }
    let(:new_playlist) { create(:playlist, title: 'Two playlist') }
    let(:video) do
      create(:video, playlist: old_playlist, title: 'One video').tap do |video|
        video.update(playlist: new_playlist, title: 'Two video', slug: nil)
      end
    end

    let!(:canonical) { "/series/#{new_playlist.slug}/#{video.slug}" }

    it 'works out of the box when visiting the new identifier' do
      get canonical
      expect(response).to have_http_status(:ok)
    end

    ['/series/one-playlist/one-video', '/series/one-playlist/two-video',
     '/series/two-playlist/one-video'].each do |path|
      it "redirects #{path} to the canonical URL" do
        get path
        aggregate_failures do
          expect(response).to have_http_status(:moved_permanently)
          expect(response).to redirect_to(canonical)
        end
      end
    end
  end

  describe 'redirections to hide internal identifiers' do
    subject { response }

    let(:video) { create(:video) }
    let(:canonical) { "/series/#{video.playlist.slug}/#{video.slug}" }

    describe 'when the video is accessed by the slugs' do
      before { get canonical }

      it { is_expected.to have_http_status(:ok) }
    end

    describe 'when the internal ID is used for the video access' do
      before { get "/series/#{video.playlist.slug}/#{video.id}" }

      it { is_expected.to have_http_status(:moved_permanently) }
      it { is_expected.to redirect_to(canonical) }
    end

    describe 'when the internal ID is used for the playlist access' do
      before { get "/series/#{video.playlist.id}/#{video.slug}" }

      it { is_expected.to have_http_status(:moved_permanently) }
      it { is_expected.to redirect_to(canonical) }
    end
  end
end
