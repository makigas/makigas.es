# frozen_string_literal: true

class RebuildSearchIndexJob < ApplicationJob
  queue_as :default

  def perform
    Search::Indexer.reindex!
  end
end
