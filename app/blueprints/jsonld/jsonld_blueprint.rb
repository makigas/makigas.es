# frozen_string_literal: true

module Jsonld
  class JsonldBlueprint < Blueprinter::Base
    def self.routes
      Rails.application.routes.url_helpers
    end

    def self.reference(name, blueprint:, **opts)
      condition = opts.delete(:if).then do |cond|
        break nil if cond.nil?

        ->(_field, object, _options) { cond.call(object) }
      end

      field(name, **opts.merge(if: condition)) do |object, options|
        blueprint.render_as_hash(object, view: :default, host: options[:host])
      end
    end

    def self.graph(&)
      field(:@graph) do |object, options|
        blueprints = []
        yield(blueprints, object)
        blueprints.map { |b| b.render_as_hash(object, view: :full, host: options[:host]) }
      end
    end
  end
end
