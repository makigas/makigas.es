# frozen_string_literal: true

module Makigas
  module Sidebar
    class BoxComponent < Makigas::Component
      renders_many :items, Makigas::Sidebar::ItemComponent

      def initialize(header: nil, **kwargs)
        super
        @header = header
      end

      private

      attr_reader :header
    end
  end
end
