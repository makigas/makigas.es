# frozen_string_literal: true

module Six
  module Base
    class ButtonGroupComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      def list
        render(Six::Base::ButtonGroupComponent.new) do |g|
          g.button(href: '?prev') { 'Anterior' }
          g.button(href: '?home') { 'Regresar' }
          g.button(href: '?next') { 'Siguiente' }
        end
      end

      def flex
        render(Six::Base::ButtonGroupComponent.new(style: :flex)) do |g|
          g.button(href: '?prev') { 'Anterior' }
          g.button(href: '?home') { 'Regresar' }
          g.button(href: '?next') { 'Siguiente' }
        end
      end

      def fill
        render(Six::Base::ButtonGroupComponent.new(style: :fill)) do |g|
          g.button(href: '?prev') { 'Anterior' }
          g.button(href: '?home') { 'Regresar' }
          g.button(href: '?next') { 'Siguiente' }
        end
      end
    end
  end
end
