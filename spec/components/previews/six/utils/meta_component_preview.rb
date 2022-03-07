# frozen_string_literal: true

module Six
  module Utils
    # Meta information
    class MetaComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a meta item. Meta components wrap some text near an icon that
      # uses the Feather design system. To create a meta component, provide
      # the icon to use and yield the content to put near the icon.
      #
      # @param icon text the icon to use for this component
      # @param text text the text to render in the component
      # @display max_width 400px
      # @display padding 30px
      def default(icon: 'list', text: '5 episodios')
        render Six::Utils::MetaComponent.new(icon: icon, text: text)
      end

      # For more complex meta blocks, it is also possible to use a block.
      # However, because the contents will be rendered inline, it is best to
      # keep this simple and only use basic rich text formatting, maybe
      # with a link.
      #
      # @display max_width 400px
      # @display padding 30px
      def using_a_block
        render(Six::Utils::MetaComponent.new(icon: 'dollar-sign')) do
          tag.strong "Gratis si eres parte de #{tag.a 'makigas+', href: '#'}"
        end
      end

      # Renders a MetaGroup, which contains more metas inside.
      #
      # @display padding 30px
      def list_of_metas
        render Six::Utils::MetaGroupComponent.new do |group|
          group.meta(icon: 'list') { '5 vídeos' }
          group.meta(icon: 'play-circle') { '10 horas' }
          group.meta(icon: 'dollar-sign') { 'Gratis' }
        end
      end

      def with_dark_background
        component = Six::Utils::MetaComponent.new(icon: 'list', text: '5 episodios')
        render ViewComponentContrib::WrapperComponent.new(component) do |wrapper|
          wrapper.content_tag(:div, style: 'padding: 30px; background: #333; color: #eee') do
            wrapper.component
          end
        end
      end
    end
  end
end
