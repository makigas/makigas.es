# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Five::Catalog::TopicMediaCardComponent, type: :component do
  describe 'default rendering' do
    subject { render_inline(described_class.new(topic:)) }

    let(:topic) { create(:topic) }
    let(:selector_thumb) { "img[src='#{topic.thumbnail.url(:small)}'][srcset~='#{topic.thumbnail.url(:default)} 2x']" }

    it { is_expected.to have_css 'h4', text: topic.title }
    it { is_expected.to have_css 'p', text: topic.description }
    it { is_expected.to have_css "a[href*='#{topic.slug}']" }
    it { is_expected.to have_selector selector_thumb }
  end
end
