# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Six::Search::ResultTopicComponent, type: :component do
  describe 'when a topic is given' do
    subject { render_inline(described_class.new(topic:)) }

    let(:topic) { build(:topic, title: 'My topic', slug: 'my-topic') }

    it { is_expected.to have_text('Tema: My topic') }
  end

  describe 'when a topic is not given' do
    subject { render_inline(described_class.new(topic: nil)) }

    it { is_expected.not_to have_text('Tema:') }
  end
end
