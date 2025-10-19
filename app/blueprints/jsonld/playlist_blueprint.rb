# frozen_string_literal: true

module Jsonld
  class PlaylistBlueprint < Jsonld::JsonldBlueprint
    transform Jsonld::CamelTransformer

    field(:@context) { 'https://schema.org/' }

    graph do |blueprints, _playlist|
      blueprints << Playlist::PublisherBlueprint
      blueprints << Playlist::WebpageBlueprint
      blueprints << Playlist::SeriesBlueprint
    end
  end
end
