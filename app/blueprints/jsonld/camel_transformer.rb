# frozen_string_literal: true

module Jsonld
  class CamelTransformer < Blueprinter::Transformer
    def transform(hash, _obj, _opts)
      hash.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end
  end
end
