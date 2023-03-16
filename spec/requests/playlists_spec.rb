# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Playlists' do
  describe 'redirections to hide internal identifiers' do
    subject { response }

    let(:playlist) { create(:playlist) }
    let(:canonical) { "/series/#{playlist.slug}" }

    describe 'when the playlist is accessed by the slugs' do
      before { get canonical }

      it { is_expected.to have_http_status :ok }
    end

    describe 'when the playlist is accessed by the internal ID' do
      before { get "/series/#{playlist.id}" }

      it { is_expected.to have_http_status(:moved_permanently) }
      it { is_expected.to redirect_to(canonical) }
    end
  end
end
