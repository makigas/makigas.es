# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Six::Search::ResultTagsComponent, type: :component do
  describe 'when tags are given' do
    subject { render_inline(described_class.new(tags: %w[c java git])) }

    it { is_expected.to have_text('Etiquetas:') }
    it { is_expected.to have_link('c') }
    it { is_expected.to have_link('java') }
    it { is_expected.to have_link('git') }
  end

  describe 'when tags are not given' do
    subject { render_inline(described_class.new(tags: nil)) }

    it { is_expected.not_to have_text('Etiquetas:') }
  end

  describe 'when the tag array is empty' do
    subject { render_inline(described_class.new(tags: [])) }

    it { is_expected.not_to have_text('Etiquetas:') }
  end
end
