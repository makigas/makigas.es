# frozen_string_literal: true

class RebuildSearchIndexJob < ApplicationJob
  queue_as :default

  def perform
    Video.visible.reindex!
    Tag.deploy_synonyms
  end
end
