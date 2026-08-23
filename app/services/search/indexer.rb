# frozen_string_literal: true

module Search
  class Indexer
    class << self
      def reindex!(async: true)
        Video.reindex!(1000, !async)
        Playlist.reindex!(1000, !async)
        Tag.deploy_synonyms
      end
    end
  end
end
