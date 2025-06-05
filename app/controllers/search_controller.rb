# frozen_string_literal: true

class SearchController < ApplicationController
  rescue_from Meilisearch::CommunicationError, with: :communication_error

  def index
    @search_request = Search::Request.new(search_filters)
    @tag = Tag.find_by(slug: search_filters.tag) if search_filters.tag.present?
  end

  private

  def communication_error
    render :search_down
  end

  def search_params
    @search_params ||= params.permit(:q, :pagina, :type, :tag, :orden, :'sin-obsoletos', :articulos).tap do |params|
      params[:orden] = (params[:q].present? ? 'relevancia' : 'reciente') if params[:orden].blank?
    end
  end

  def search_filters
    @search_filters ||= Search::QueryParamsDeserializer.convert(search_params).tap do |filters|
      filters.per_page = 10
    end
  end
end
