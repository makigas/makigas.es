# frozen_string_literal: true

class SearchEngine
  include Rake::DSL

  def initialize
    namespace :makigas do
      desc 'Update search engine index'
      task(reindex: :environment) { RebuildSearchIndexJob.perform_now }
    end
  end
end

SearchEngine.new
