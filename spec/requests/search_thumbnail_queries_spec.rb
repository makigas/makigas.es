# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search thumbnail queries' do
  def artwork_queries
    queries = []
    subscriber = lambda do |*args|
      payload = args.last
      queries << payload[:sql] if payload[:sql].match?(/SELECT.*"active_storage_(attachments|blobs)"/)
    end

    ActiveSupport::Notifications.subscribed(subscriber, 'sql.active_record') { get '/explorar/cursos' }

    queries.size
  end

  it 'keeps artwork queries constant as the result count grows', :aggregate_failures do
    create_list(:video, 3, :published_yesterday)
    Search::Indexer.reindex!(async: false)
    initial_queries = artwork_queries
    expect(Capybara.string(response.body)).to have_css('.SearchResult', count: 3)

    create_list(:video, 3, :published_yesterday)
    Search::Indexer.reindex!(async: false)

    expect(artwork_queries).to eq(initial_queries)
    expect(response).to have_http_status(:ok)
    expect(Capybara.string(response.body)).to have_css('.SearchResult', count: 6)
    expect(Capybara.string(response.body)).to have_css('.SearchResult__icon[src*="/rails/active_storage/"]', count: 6)
  end
end
