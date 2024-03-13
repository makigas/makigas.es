# frozen_string_literal: true

module Six
  module Base
    class ButtonComponent < ViewComponent::Base
      def initialize(**options)
        super
        @href = options[:href]
        @classes = options[:classes]
        @id = options[:id]
        @text = options[:text]
        @rel = options[:rel]
        @target = options[:target]
      end

      private

      attr_reader :href, :classes, :id, :text, :rel, :target

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
