# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update slug' do
  let(:video) do
    create(:video, title: 'Original slug').tap do |v|
      v.update(slug: 'old-slug')
    end
  end

  before do
    host! 'dashboard.lvh.me'
  end

  it 'passes the slug smoke test' do
    expect(video.slug).to eq 'old-slug'
  end

  describe 'without a login' do
    it 'redirects to login' do
      put '/videos/modal/slug', params: { modal_slug: { id: video.id, slug: 'new-slug' } }
      expect(response).to redirect_to '/users/sign_in'
    end

    it 'does not change the video' do
      put '/videos/modal/slug', params: { modal_slug: { id: video.id, slug: 'new-slug' } }
      video.reload
      expect(video).to have_attributes(slug: 'old-slug')
    end
  end

  describe 'with a login' do
    let(:user) { create(:user) }

    before do
      sign_in user, scope: :user
    end

    describe 'when the request is valid for changing attributes' do
      it 'redirects to the video page' do
        put '/videos/modal/slug', params: { modal_slug: { id: video.id, slug: 'new-slug' } }
        video.reload
        expect(response).to redirect_to "/playlists/#{video.playlist.slug}/videos/#{video.slug}"
      end

      it 'updates the video slug' do
        put '/videos/modal/slug', params: { modal_slug: { id: video.id, slug: 'new-slug' } }
        video.reload
        expect(video).to have_attributes(slug: 'new-slug')
      end
    end

    describe 'when the request is valid for resetting attributes' do
      it 'redirects to the video page' do
        put '/videos/modal/slug', params: { modal_slug: { id: video.id, reset: '1' } }
        video.reload
        expect(response).to redirect_to "/playlists/#{video.playlist.slug}/videos/#{video.slug}"
      end

      it 'updates the video slug' do
        put '/videos/modal/slug', params: { modal_slug: { id: video.id, reset: '1' } }
        video.reload
        expect(video).to have_attributes(slug: 'original-slug')
      end
    end
  end
end
