# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Six::Search::ResultComponent, type: :component do
  describe 'with a full example' do
    subject { render_inline(described_class.new(video:)) }

    let(:playlist) { build(:playlist) }
    let(:video) { build(:video, playlist:) }

    it { is_expected.to have_link video.title }
    it { is_expected.to have_text video.description }

    it { is_expected.to have_text 'Curso:' }
  end

  describe 'without tags' do
    subject { render_inline(described_class.new(video:)) }

    let(:playlist) { build(:playlist) }
    let(:video) { build(:video, playlist:, tags: nil) }

    it { is_expected.to have_link video.title }
    it { is_expected.to have_text video.description }

    it { is_expected.to have_text 'Curso:' }
  end
end
