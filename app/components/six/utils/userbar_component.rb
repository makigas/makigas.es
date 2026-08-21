# frozen_string_literal: true

module Six
  module Utils
    class UserbarComponent < ViewComponent::Base
      include Makigas::ViewHelper

      def initialize(warden:)
        super()
        @warden = warden
      end

      private

      attr_reader :warden

      delegate :user, to: :warden
    end
  end
end
