# frozen_string_literal: true

module Six
  module Base
    class ButtonGroupComponent < ViewComponent::Base
      renders_many :buttons, Six::Base::ButtonComponent

      def initialize(style: :list)
        super
        @style = style
      end

      private

      attr_reader :style

      ALTERNATE_STYLE_CLASSES = {
        flex: 'flex',
        fill: 'fill'
      }.freeze

      def class_list
        classes = ['btngroup']
        classes << "btngroup--#{ALTERNATE_STYLE_CLASSES[style]}" if ALTERNATE_STYLE_CLASSES[style]
        classes.flatten.join(' ')
      end
    end
  end
end
