# frozen_string_literal: true

class SearchEngine
  include Rake::DSL

  def initialize
    namespace :makigas do
      desc 'Update search engine index'
      task(reindex: :environment) { Makigas::Indexer.reindex! }
    end
  end
end

SearchEngine.new
