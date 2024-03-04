# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Six::Search::ResultPlaylistComponent, type: :component do
  describe 'when a playlist is given' do
    subject { render_inline(described_class.new(playlist:)) }

    let(:playlist) { build(:playlist, title: 'My playlist', slug: 'my-playlist') }

    it { is_expected.to have_text('Serie: My playlist') }
  end

  describe 'when a playlist is not given' do
    subject { render_inline(described_class.new(playlist: nil)) }

    it { is_expected.to have_no_text('Serie:') }
  end
end
