# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModalSlug do
  let(:video) { create(:video, title: 'My video', slug: 'old-slug') }
  let(:instance) { described_class.new(id: video.id) }

  describe 'when changing the slug of a video' do
    it 'supports a custom slug' do
      instance.slug = 'another-slug'
      instance.update_slug!
      expect(video.reload.slug).to eq 'another-slug'
    end

    it 'supports a pre-generated slug' do
      instance.reset = true
      instance.update_slug!
      expect(video.reload.slug).to eq 'my-video'
    end
  end
end
