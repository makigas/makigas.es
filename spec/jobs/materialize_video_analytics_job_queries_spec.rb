# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MaterializeVideoAnalyticsJob do
  subject(:job) { described_class.new }

  let(:playlist) { create(:playlist) }
  let!(:videos) { create_list(:video, 4, :published_yesterday, playlist:) }
  let(:routes) { Rails.application.routes.url_helpers }

  it 'batches slug and document reads while retaining historical page views', :aggregate_failures do
    video = videos.first
    historical_path = routes.playlist_video_path(playlist, video)
    video.update!(playlist: create(:playlist))
    pages = videos.map { |item| { page: routes.playlist_video_path(item.playlist, item), pageviews: 10 } }
    create(:ingested_analytic, day: Date.current, document: pages + [{ page: historical_path, pageviews: 7 }])
    queries = []
    subscriber = lambda do |*args|
      payload = args.last
      queries << payload[:sql] unless payload[:cached]
    end

    ActiveSupport::Notifications.subscribed(subscriber, 'sql.active_record') { job.update_counters }

    expect(video.reload).to have_attributes(views_total: 17, views_recent: 17)
    expect(videos.last.reload).to have_attributes(views_total: 10, views_recent: 10)
    expect(queries.grep(/SELECT.*FROM "friendly_id_slugs"/).size).to be <= 4
    expect(queries.grep(/SELECT.*FROM "documents"/).size).to be <= 2
    expect(queries.grep(/SELECT.*FROM "playlists".*WHERE "playlists"\."id" =/).size).to be <= 2
  end
end
