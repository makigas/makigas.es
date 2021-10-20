# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @videos = if searches?
                Video.search(params[:q], { filter: search_filters, hitsPerPage: 10, page: params[:page] || 1 })
              else
                Video.includes(:playlist, playlist: :topic).visible.joins(:playlist)
                     .order(published_at: :desc).page(params[:page]).per(10)
              end
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    authenticate_user! if @video.scheduled? && @video.private
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end

  def feed
    @videos = Video.visible.includes(:playlist, playlist: [:topic]).order(published_at: :desc).limit(15)
    @updated_at = Video.order(updated_at: :desc).limit(1).pick(:updated_at)
    render format: :xml, template: 'videos/feed.xml.erb', layout: false
  end

  def find_by_id
    @video = Video.find_by!(youtube_id: params[:id])
    redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
  end

  private

  def searches?
    %i[q topic length].any? { |p| params[p].present? }
  end

  def search_filters
    (search_lengths + [search_topics])
  end

  def search_lengths
    return [] if params[:length].blank?

    LENGTH_QUERIES[params[:length]]
  end

  def search_topics
    return [] if params[:topic].blank?

    # I don't know yet if Meilisearch will prevent me from dangerous strings
    # but sure I know ActiveRecord will, so let's filter the topics first.
    # Update: maybe they don't: https://github.com/meilisearch/MeiliSearch/issues/1409
    topics = Topic.where(slug: params[:topic]).pluck(:slug)
    topics.map { |t| "topic_slug = #{t}" }
  end

  LENGTH_QUERIES = {
    'short' => ['duration <= 300'],
    'medium' => ['duration > 300', 'duration <= 900'],
    'long' => ['duration > 900'],
    'all' => []
  }.freeze
end
