# frozen_string_literal: true

module Jsonld
  class VideoBlueprint < Jsonld::JsonldBlueprint
    transform Jsonld::CamelTransformer

    field(:@context) { 'https://schema.org/' }

    field(:@graph) do |video, options|
      nodes = [].tap do |graph|
        graph << PublisherBlueprint.render_as_hash(video, view: :full, host: options[:host])
        graph << Video::WebpageBlueprint.render_as_hash(video, view: :full, host: options[:host])
        if video.user.present?
          graph << User::AuthorBlueprint.render_as_hash(video.user, view: :full,
                                                                    host: options[:host])
        end
        graph << Video::ThumbnailBlueprint.render_as_hash(video, view: :full, host: options[:host])
        graph << Video::VideoObjectBlueprint.render_as_hash(video, view: :full, host: options[:host])
        graph << Playlist::SeriesBlueprint.render_as_hash(video.playlist, view: :full, host: options[:host])
        graph << Video::EpisodeBlueprint.render_as_hash(video, view: :full, host: options[:host])
        if video.show_note.present?
          graph << Video::ArticleBlueprint.render_as_hash(video, view: :full,
                                                                 host: options[:host])
        end
      end
      nodes.uniq { |node| node['@id'] }
    end
  end
end
