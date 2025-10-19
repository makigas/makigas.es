# frozen_string_literal: true

module Jsonld
  class PublisherBlueprint < Jsonld::JsonldBlueprint
    transform Jsonld::CamelTransformer

    identifier(:@id) do |_, options|
      routes.root_url(anchor: 'publisher', host: options[:host])
    end

    view(:full) do
      field(:@type) { 'Organization' }
      field(:name) { 'Makigas' }
      field(:url) { 'https://www.makigas.es' }
    end
  end
end
