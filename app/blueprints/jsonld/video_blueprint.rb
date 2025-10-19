# frozen_string_literal: true

module Jsonld
  class VideoBlueprint < Jsonld::JsonldBlueprint
    transform Jsonld::CamelTransformer

    field(:@context) { 'https://schema.org/' }

    graph do |blueprints, video|
      blueprints << Video::PublisherBlueprint
      blueprints << Video::WebpageBlueprint
      blueprints << Video::AuthorBlueprint if video.user.present?
      blueprints << Video::ThumbnailBlueprint
      blueprints << Video::VideoObjectBlueprint
      blueprints << Video::SeriesBlueprint
      blueprints << Video::EpisodeBlueprint
      blueprints << Video::ArticleBlueprint if video.show_note.present?
    end
  end
end
