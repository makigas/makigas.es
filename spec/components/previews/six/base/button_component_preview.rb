# frozen_string_literal: true

module Six
  module Base
    class ButtonComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      def as_link
        render(Six::Base::ButtonComponent.new(href: '/')) { 'Continuar' }
      end

      def as_button
        render(Six::Base::ButtonComponent.new(id: 'click_me')) { 'Hazme clic' }
      end

      def integrated
        component = Six::Base::ButtonComponent.new(id: 'click_me', text: 'Click aquí')
        render ViewComponentContrib::WrapperComponent.new(component) do |wrapper|
          # rubocop:disable Rails/OutputSafety
          wrapper.content_tag(:p) { "Para ver más opciones, #{wrapper.component}".html_safe }
          # rubocop:enable Rails/OutputSafety
        end
      end

      def with_more_classes
        render(Six::Base::ButtonComponent.new(classes: 'test')) { 'Test' }
      end
    end
  end
end
