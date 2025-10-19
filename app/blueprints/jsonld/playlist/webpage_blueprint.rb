# frozen_string_literal: true

module Jsonld
  module Playlist
    class WebpageBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |playlist, options|
        routes.playlist_url(playlist, anchor: 'webpage', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'WebPage' }

        field(:name) { |playlist| "#{playlist.title} – makigas" }
        field(:description)

        reference(:publisher, blueprint: PublisherBlueprint)
      end
    end
  end
end
