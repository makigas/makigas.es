# frozen_string_literal: true

module Six
  module Lesson
    class TeacherComponent < ViewComponent::Base
      attr_reader :user

      def initialize(user: nil)
        super
        @user = user
      end

      def render?
        @user.present?
      end
    end
  end
end
