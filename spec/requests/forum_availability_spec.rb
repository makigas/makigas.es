# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Video forum suggestions' do
  let(:video) { create(:video, :published_yesterday) }
  let(:path) { playlist_video_path(video.playlist, video) }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:discussion) do
    { data: [{ type: 'discussions', id: '1',
               attributes: { title: 'Related discussion', slug: 'related-discussion', createdAt: 1.day.ago.iso8601 },
               relationships: { user: { data: { type: 'users', id: '2' } } } }],
      included: [{ type: 'users', id: '2', attributes: { slug: 'teacher' } }] }
  end

  before do
    allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache::MemoryStore.new)
    allow(Faraday).to receive(:new).and_wrap_original do |original, *args, **kwargs, &block|
      original.call(*args, **kwargs, &block).tap { |connection| connection.adapter :test, stubs }
    end
  end

  def forum_response(status, body)
    stubs.get('/api/discussions') { [status, { 'Content-Type' => 'application/json' }, body.to_json] }
  end

  it 'renders the forum fallback after a failed response and retries on the next visit', :aggregate_failures do
    forum_response(502, { errors: [{ code: 'upstream_failure' }] })
    forum_response(200, discussion)

    get path

    expect(response).to have_http_status(:ok)
    expect(Capybara.string(response.body)).to have_link('Visitar el foro', href: %r{\Ahttps://foro\.makigas\.es(?:\?|$)})
    expect(Capybara.string(response.body)).to have_text(video.title)

    get path

    expect(response).to have_http_status(:ok)
    expect(Capybara.string(response.body)).to have_link('Related discussion',
                                                        href: 'https://foro.makigas.es/d/related-discussion')
    stubs.verify_stubbed_calls
  end
end
