# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Six::Search::ResultComponent, type: :component do
  describe 'with a full example' do
    subject { render_inline(described_class.new(video:)) }

    let(:topic) { build(:topic) }
    let(:playlist) { build(:playlist, topic:) }
    let(:video) { build(:video, playlist:) }

    it { is_expected.to have_link video.title }
    it { is_expected.to have_text video.description }

    it { is_expected.to have_text 'Serie:' }
    it { is_expected.to have_text 'Tema:' }
    it { is_expected.to have_text 'Etiquetas:' }
  end

  describe 'without tags' do
    subject { render_inline(described_class.new(video:)) }

    let(:topic) { build(:topic) }
    let(:playlist) { build(:playlist, topic:) }
    let(:video) { build(:video, playlist:, tags: nil) }

    it { is_expected.to have_link video.title }
    it { is_expected.to have_text video.description }

    it { is_expected.to have_text 'Serie:' }
    it { is_expected.to have_text 'Tema:' }
    it { is_expected.to have_no_text 'Etiquetas:' }
  end

  describe 'without topic' do
    subject { render_inline(described_class.new(video:)) }

    let(:playlist) { build(:playlist, topic: nil) }
    let(:video) { build(:video, playlist:) }

    it { is_expected.to have_link video.title }
    it { is_expected.to have_text video.description }

    it { is_expected.to have_text 'Serie:' }
    it { is_expected.to have_no_text 'Tema:' }
    it { is_expected.to have_text 'Etiquetas:' }
  end
end
