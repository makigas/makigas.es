# frozen_string_literal: true

module Six
  module Base
    class ButtonComponent < ViewComponent::Base
      def initialize(href: nil, classes: nil, id: nil, text: nil)
        super
        @href = href
        @classes = classes
        @id = id
        @text = text
      end

      private

      attr_reader :href, :classes, :id, :text

      def class_list
        base_classes = ['btn']
        base_classes << classes if classes.present?
        base_classes.flatten.join(' ')
      end

      def inner_content
        text || content
      end
    end
  end
end
