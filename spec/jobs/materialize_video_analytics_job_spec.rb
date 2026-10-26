# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MaterializeVideoAnalyticsJob do
  subject(:job) { described_class.new }

  let!(:video) { create(:video, :published_yesterday) }
  let(:url) { Rails.application.routes.url_helpers.playlist_video_path(video.playlist, video) }

  around do |example|
    previous_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :solid_queue
    example.run
  ensure
    ActiveJob::Base.queue_adapter = previous_adapter
  end

  it 'persists counters and indexing jobs without changing the video timestamps', :aggregate_failures do
    timestamps = video.reload.attributes.slice('created_at', 'updated_at')

    expect { job.update_video_counters(video, { url => 12 }, { url => 4 }) }
      .to change { SolidQueue::Job.where(class_name: 'Meilisearch::Rails::MSJob').count }.by(1)

    expect(video.reload).to have_attributes(views_total: 12, views_recent: 4)
    expect(video.attributes.slice('created_at', 'updated_at')).to eq(timestamps)
    expect(SolidQueue::Job.last).to have_attributes(created_at: be_present, updated_at: be_present)
  end

  it 'persists playlist counters and indexing jobs without changing timestamps', :aggregate_failures do
    playlist = video.playlist
    timestamps = playlist.reload.attributes.slice('created_at', 'updated_at')
    path = Rails.application.routes.url_helpers.playlist_path(playlist)

    expect { job.update_playlist_counters(playlist, { path => 20 }, { path => 5 }) }
      .to change { SolidQueue::Job.where(class_name: 'Meilisearch::Rails::MSJob').count }.by(1)

    expect(playlist.reload).to have_attributes(views_total: 20, views_recent: 5)
    expect(playlist.attributes.slice('created_at', 'updated_at')).to eq(timestamps)
  end

  it 'restores timestamp recording when an update fails', :aggregate_failures do
    expect { job.update_without_timestamps { raise ArgumentError, 'failed update' } }
      .to raise_error(ArgumentError, 'failed update')

    expect(ApplicationRecord.record_timestamps).to be(true)
  end
end
