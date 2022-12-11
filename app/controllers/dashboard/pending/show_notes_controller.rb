# frozen_string_literal: true

module Dashboard
  module Pending
    class ShowNotesController < Dashboard::DashboardController
      before_action :assign_default_sort

      def show
        @videos = Video.unnoted.order(sort_criteria).page(params[:page])
      end

      private

      def assign_default_sort
        params[:sort] = 'duration' if params[:sort].blank?
        params[:sort] = 'duration' unless SORT_CRITERIAS.keys.include?(sort_key)
      end

      def sort_direction
        params[:sort].starts_with?('-') ? :desc : :asc
      end

      def sort_key
        params[:sort].gsub(/^[+-]/, '')
      end

      SORT_CRITERIAS = {
        'playlist' => :playlist_id,
        'publication_date' => :published_at,
        'duration' => :duration
      }.freeze

      def sort_criteria
        criteria = SORT_CRITERIAS[sort_key]
        { criteria => sort_direction }
      end
    end
  end
end
