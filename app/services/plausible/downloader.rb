# frozen_string_literal: true

module Plausible
  class Downloader
    class << self
      def entity_for_day(day)
        new(day).entity
      end
    end

    def initialize(day)
      @day = day
    end

    def entity
      @entity ||= IngestedAnalytic.new(day: @day, document: analytics)
    end

    def analytics
      @analytics ||= client.breakdown(@day)
    end

    def client
      Plausible::Integration.client
    end
  end
end
