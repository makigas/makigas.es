# frozen_string_literal: true

module Jsonld
  class PlaylistBlueprint < Jsonld::JsonldBlueprint
    transform Jsonld::CamelTransformer

    field(:@context) { 'https://schema.org/' }

    field(:@graph) do |playlist, options|
      [].tap do |graph|
        graph << PublisherBlueprint.render_as_hash(playlist, view: :full, host: options[:host])
        graph << Playlist::WebpageBlueprint.render_as_hash(playlist, view: :full, host: options[:host])
        graph << Playlist::SeriesBlueprint.render_as_hash(playlist, view: :full, host: options[:host])
      end
    end
  end
end
