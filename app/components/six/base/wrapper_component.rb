# frozen_string_literal: true

module Six
  module Base
    class WrapperComponent < ViewComponent::Base
      def initialize(**options)
        super
        @options = options
      end

      private

      def tag
        @options[:tag] || :div
      end

      def class_list
        classes = ['wrapper']
        classes << 'wrapper--fluid' if @options[:fluid]
        classes << 'wrapper--breath' if @options[:breath]
        classes << @options[:classes] if @options[:classes].present?
        classes.flatten.join(' ')
      end
    end
  end
end
