# frozen_string_literal: true

module Dashboard
  class SearchesController < Dashboard::DashboardController
    def show
      @list = SearchRequest.order(created_at: :desc).page(params[:page])
    end
  end
end
