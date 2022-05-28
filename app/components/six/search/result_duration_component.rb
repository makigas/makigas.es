# frozen_string_literal: true

module Six
  module Search
    # Takes care of rendering the total duration of the given episode.
    class ResultDurationComponent < ViewComponent::Base
      attr_reader :seconds

      # Build a new component used to present a duration.
      # @param seconds [Integer] the length of the episode in seconds.
      def initialize(seconds:)
        super
        @seconds = seconds
      end

      def call
        render Six::Utils::MetaComponent.new(icon: 'clock', preffix: 'Duración:') do
          helpers.running_time(seconds)
        end
      end
    end
  end
end
