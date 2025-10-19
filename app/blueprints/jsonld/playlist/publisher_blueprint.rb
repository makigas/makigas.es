# frozen_string_literal: true

module Jsonld
  module Playlist
    class PublisherBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |playlist, options|
        routes.playlist_url(playlist, anchor: 'publisher', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'Organization' }
        field(:name) { 'Makigas' }
        field(:url) { 'https://www.makigas.es' }
      end
    end
  end
end
