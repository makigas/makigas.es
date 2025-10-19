# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'jsonld/article.json.jbuilder' do
  include ActiveSupport::Testing::TimeHelpers

  subject(:json) do
    render template: 'jsonld/article', formats: :json, locals: { article: }
    JSON.parse(rendered)
  end

  before do
    travel_to Time.utc(2024, 6, 9, 14, 25, 32)
  end

  let(:playlist) { create(:playlist, title: 'Java') }
  let(:user) { create(:user, name: 'John Doe') }
  let(:article) do
    create(:video, playlist:, user:,
                   title: 'Install Java',
                   excerpt: 'Video excerpt',
                   description: 'This video is a review of the process on how to install Java',
                   youtube_id: 'asdf1234',
                   published_at: 2.days.ago,
                   duration: 351)
  end

  it 'renders a Article schema with core attributes' do
    expect(json).to match(
      '@context' => 'https://schema.org',
      '@type' => 'Article',
      'author' => hash_including(
        'name' => 'John Doe'
      )
    )
  end
end
