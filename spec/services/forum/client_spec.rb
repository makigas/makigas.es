# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forum::Client do
  it 'fetches discussions and resolves their related users, tags and first posts' do
    discussions = described_class.new.request(Forum::DiscussionsTaggedAs.new('music', 'video'))
    discussion = discussions.fetch('discussions/1')

    aggregate_failures do
      expect(discussion['title']).to eq('Example discussion 1')
      expect(discussion['user']['slug']).to start_with('example-users-')
      expect(discussion['tags']).to all(include('name' => a_string_starting_with('Example tag ')))
      expect(discussion['firstPost']['contentHtml']).to eq('<p>A fictional question about programming.</p>')
      expect(WebMock).to have_requested(:get, 'https://foro.makigas.es/api/discussions').with(
        query: { 'filter' => { 'tag' => 'music,video' }, 'page' => { 'limit' => '5' }, 'sort' => '-createdAt' }
      ).once
    end
  end

  it 'blocks forum endpoints without a stub' do
    expect do
      Faraday.get('https://foro.makigas.es/api/users')
    end.to raise_error(WebMock::NetConnectNotAllowedError)
  end
end
