# frozen_string_literal: true

module Six
  module Lesson
    class QuestionComponent < ViewComponent::Base
      def initialize(forum: nil, utm: nil)
        super
        @forum = forum
        @utm = utm
      end

      attr_reader :forum

      def sub_forum_url
        has_query_string = @forum.include?('?')
        [@forum, utm_query].compact.join(has_query_string ? '&' : '?')
      end

      def root_forum_url
        ['https://foro.makigas.es', utm_query].compact.join('?')
      end

      private

      def utm_query
        utm_params.then { |utm| utm.present? ? utm.to_query : nil }
      end

      def utm_params
        params = (@utm || {}).map do |key, value|
          key = "utm_#{key}" unless key.to_s.starts_with?('utm')
          [key.to_sym, value]
        end
        params.to_h
      end
    end
  end
end
