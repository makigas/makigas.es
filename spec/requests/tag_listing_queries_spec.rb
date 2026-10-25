# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tag listing queries' do
  before do
    3.times { |i| create(:tag, title: "Topic #{i}", slug: "topic-#{i}") }
  end

  ['/', '/temas'].each do |path|
    it "loads tag artwork in batches on #{path}", :aggregate_failures do
      queries = []
      subscriber = lambda do |*args|
        payload = args.last
        queries << payload[:sql] if payload[:sql].match?(/SELECT.*"active_storage_(attachments|blobs)"/)
      end

      ActiveSupport::Notifications.subscribed(subscriber, 'sql.active_record') { get path }

      expect(response).to have_http_status(:ok)
      expect(Capybara.string(response.body)).to have_link('Topic 0', href: '/explorar/tema/topic-0')
      expect(Capybara.string(response.body)).to have_css('img[src*="/rails/active_storage/"]', minimum: 3)
      expect(queries.grep(/FROM "active_storage_attachments"/).size).to be <= 2
      expect(queries.grep(/FROM "active_storage_blobs"/).size).to eq(1)
    end
  end
end
