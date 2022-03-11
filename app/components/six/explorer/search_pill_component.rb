# frozen_string_literal: true

module Six
  module Explorer
    class SearchPillComponent < ViewComponent::Base
      def initialize(url: nil, active: false)
        super
        @url = url
        @active = active
      end

      private

      attr_reader :url, :active

      def classes
        base = ['videoexplorer__search__pill']
        base << 'videoexplorer__search__pill--active' if active
        base.join(' ')
      end
    end
  end
end
