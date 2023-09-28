# frozen_string_literal: true

class VideosController < ApplicationController
  rescue_from Makigas::SearchError, with: :search_error

  def search_error
    render :search_error, status: :service_unavailable
  end

  def index
    @videos = if filter_params.present?
                VideoSearch.new(params[:q], filters: filter_params, page:).videos
              else
                Video.visible.includes(playlist: :topic).order(published_at: :desc).page(page).per(10)
              end
  end

  def show
    find_video
    raise ActiveRecord::RecordNotFound unless @video.present? && @video.visible?

    redirect_to [@video.playlist, @video], status: :moved_permanently unless canonical_params?
  end

  def find_by_id
    @video = Video.find_by!(youtube_id: params[:id])
    redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
  end

  def early
    @videos = Video.early_access
    respond_to do |format|
      format.json
    end
  end

  private

  def find_video
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id], allow_nil: true)
    find_video_in_old_playlist if @video.blank?
  end

  # Second chance: the video was not found in this playlist, let's see if the URL points
  # an old permalink by checking videos that *used* to be in this playlist and test if
  # any of these videos has or used to have the video slug provided in the permalink.
  def find_video_in_old_playlist
    old_videos = Video.filter_by_old_playlist_id(@playlist.id)
    @video = old_videos.friendly.find(params[:id], allow_nil: true)
    @playlist = @video.playlist if @video.present?
  end

  def page
    params.fetch(:page, 1)
  end

  def filter_params
    params.permit(:q, :length, :tag, topic: [])
  end

  def canonical_params?
    params[:playlist_id] == @playlist.slug && params[:id] == @video.slug
  end
end
