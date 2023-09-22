# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Five::Catalog::PlaylistMediaCardComponent, type: :component do
  describe 'default rendering' do
    subject { render_inline(described_class.new(playlist:)) }

    let(:playlist) { create(:playlist) }
    let(:selector_thumb) do
      "img[src='#{playlist.thumbnail.url(:small)}'][srcset~='#{playlist.thumbnail.url(:default)} 2x']"
    end

    it { is_expected.to have_css 'h4', text: playlist.title }
    it { is_expected.to have_css 'p', text: /0 episodios/ }
    it { is_expected.to have_selector "a[href*='#{playlist.slug}']" }
    it { is_expected.to have_selector selector_thumb }

    describe 'when the playlist has a video' do
      before { create(:video, playlist:) }

      it { is_expected.not_to have_css 'p', text: /1 episodio/ }
    end

    describe 'when the playlist have multiple videos' do
      before { create_list(:video, 2, playlist:) }

      it { is_expected.to have_css 'p', text: /2 episodios/ }
    end
  end
end
