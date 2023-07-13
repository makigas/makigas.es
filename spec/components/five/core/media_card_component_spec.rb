# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Five::Core::MediaCardComponent, type: :component do
  describe 'default rendering' do
    subject do
      render_inline(described_class.new(href: '/cards/example-card',
                                        thumbnail: '/images/foobar.jpg',
                                        hidef_thumbnail: '/images/foobar@2x.jpg')) do |c|
        c.with_title { 'Example' }
        c.with_text { 'This is the content' }
      end
    end

    it { is_expected.to have_selector 'h4', text: 'Example' }
    it { is_expected.to have_selector 'p', text: 'This is the content' }
    it { is_expected.to have_link href: '/cards/example-card' }
    it { is_expected.to have_selector 'img[src="/images/foobar.jpg"][srcset~="/images/foobar@2x.jpg 2x"]' }
  end
end
