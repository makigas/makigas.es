# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'jsonld/video.json.jbuilder' do
  include ActiveSupport::Testing::TimeHelpers

  subject(:json) do
    render template: 'jsonld/video', formats: :json, locals: { video: }
    JSON.parse(rendered)
  end

  before do
    travel_to Time.utc(2024, 6, 9, 14, 25, 32)
  end

  let(:playlist) { create(:playlist, title: 'Java') }
  let(:video) do
    create(:video, playlist:, title: 'Install Java',
                   excerpt: 'Video excerpt',
                   description: 'This video is a review of the process on how to install Java',
                   youtube_id: 'asdf1234',
                   published_at: 2.days.ago,
                   duration: 351)
  end

  it 'renders a VideoObject schema with core attributes' do
    expect(json).to match(
      '@context' => 'https://schema.org',
      '@type' => 'VideoObject',
      'name' => 'Install Java',
      'description' => 'Video excerpt',
      'thumbnailUrl' => 'https://i1.ytimg.com/vi/asdf1234/maxresdefault.jpg',
      'uploadDate' => '2024-06-07T14:25:32Z',
      'duration' => 'PT5M51S',
      'embedUrl' => 'https://www.youtube.com/embed/asdf1234',
      'sameAs' => 'https://www.youtube.com/watch?v=asdf1234',
      'url' => 'http://test.host/series/java/install-java'
    )
  end
end
