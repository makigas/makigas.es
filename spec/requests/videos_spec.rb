# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos' do
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

      it { is_expected.to redirect_to(canonical) }
    end

    describe 'when the internal ID is used for the playlist access' do
      before { get "/series/#{video.playlist.id}/#{video.slug}" }

      it { is_expected.to redirect_to(canonical) }
    end
  end
end
