# frozen_string_literal: true

module Six
  module Front
    class TopicExplorerComponent < ViewComponent::Base
      private

      CUSTOM_NAMES = {
        'mejora-tus-skills' => 'Skills nuevas',
        'desarrollo-web' => 'Desarrollo web',
        'lenguajes-de-programacion' => 'Programación',
        'java' => 'Java',
        'desarrollo-de-juegos' => 'Desarrollo de juegos'
      }.freeze

      def topics
        Topic.all.index_by(&:slug)
      end

      def each_topic(&)
        CUSTOM_NAMES.map { |slug, name| [topics[slug], name] }.reject { |k, _| k.nil? }.each(&)
      end
    end
  end
end
