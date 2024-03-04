# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Six::Search::PillComponent, type: :component do
  describe 'regular pills' do
    subject { render_inline(described_class.new(url: '/foo-bar').with_content('Foo Bar')) }

    it { is_expected.to have_link 'Foo Bar', href: '/foo-bar' }
    it { is_expected.to have_no_xpath "//a[contains(@class, '--active')]" }
  end

  describe 'active pills' do
    subject { render_inline(described_class.new(url: '/foo-bar', active: true).with_content('Foo Bar')) }

    it { is_expected.to have_link 'Foo Bar', href: '/foo-bar' }
    it { is_expected.to have_xpath "//a[contains(@class, '--active')]" }
  end
end
