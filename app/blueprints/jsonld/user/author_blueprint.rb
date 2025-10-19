# frozen_string_literal: true

module Jsonld
  module User
    class AuthorBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |user, options|
        # The URL does not exist at the moment.
        ActionDispatch::Http::URL.url_for(path: "/users/#{user.id}", anchor: :author, host: options[:host])
      end

      view(:full) do
        field(:@type) { 'Person' }
        field(:name)
        field(:external_url, name: :url, exclude_if_nil: true)
      end
    end
  end
end
