# frozen_string_literal: true

module Six
  module Search
    # The pill is one of the links provided in the sidebar of a search page.
    # It allows to modify the filters used to limit the scope of whatever
    # results are being presented, such as filtering by tag or by length.
    class PillComponent < ViewComponent::Base
      # Build a new pill.
      # @param url [string] the URL where the pill should point to
      # @param active [boolean] whether to display the pill as active or not
      # @param icon_right [string] if given, a feather icon to put after the text
      def initialize(url: nil, active: false, icon_right: nil)
        super
        @url = url
        @active = active
        @icon_right = icon_right
      end

      def call
        link_to(url, class: classes) do
          safe_join([content, right_icon])
        end
      end

      private

      attr_reader :url, :active, :icon_right

      def right_icon
        feather_icon(icon_right, class: 'searchpill__icon') if icon_right.present?
      end

      def classes
        base = ['searchpill']
        base << 'searchpill--active' if active
        base.join(' ')
      end
    end
  end
end
