# frozen_string_literal: true

module Search
  class Indexer
    class << self
      def reindex!(async: true)
        Video.reindex!(1000, !async)
        Playlist.reindex!(1000, !async)
      end
    end
  end
end
