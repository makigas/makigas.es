# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Meilisearch::Rails::MSJob do
  around do |example|
    previous_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :solid_queue
    example.run
  ensure
    ActiveJob::Base.queue_adapter = previous_adapter
  end

  it 'stores asynchronous indexing work in the meilisearch queue' do
    expect do
      create(:video)
    end.to change(ready_meilisearch_executions, :count).by(1)
  end

  def ready_meilisearch_executions
    SolidQueue::ReadyExecution.joins(:job).where(solid_queue_jobs: { queue_name: 'meilisearch' })
  end
end
