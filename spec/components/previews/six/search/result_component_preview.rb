# frozen_string_literal: true

module Six
  module Search
    # @label Search result
    class ResultComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders the search results for a video part of a playlist
      # @param title text
      def video_with_playlist
        playlist = Playlist.new(title: 'My playlist', slug: 'my-playlist')
        video = Video.new(title: 'Video', description: 'This is an example video', slug: 'my-video',
                          tags: %w[c java git], duration: 345, playlist:)
        render(Six::Search::ResultComponent.new(video:))
      end

      def video_with_playlist_and_topic
        topic = Topic.new(title: 'My topic', slug: 'my-topic')
        playlist = Playlist.new(title: 'My playlist', slug: 'my-playlist', topic:)
        video = Video.new(title: 'Video', description: 'This is an example video', slug: 'my-video',
                          tags: %w[c java git], duration: 345, playlist:)
        render(Six::Search::ResultComponent.new(video:))
      end
    end
  end
end
