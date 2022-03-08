# frozen_string_literal: true

module Six
  module Utils
    # The meta group component can be used to render a list of meta entities
    # which should be presented one next to the another. In desktop, they
    # will be presented in an horizontal strip, but on mobile they will be
    # presented as a vertical list.
    class MetaGroupComponent < ViewComponent::Base
      renders_many :metas, Six::Utils::MetaComponent

      def initialize(tag: 'div', classes: nil)
        super
        @tag = tag
        @classes = classes
      end

      def class_list
        class_list = ['metas']
        class_list << classes if classes.present?
        class_list.flatten.join(' ')
      end

      private

      attr_reader :tag, :classes
    end
  end
end
