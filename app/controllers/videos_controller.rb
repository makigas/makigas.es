# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @videos = if filter_params.present?
                VideoSearch.new(params[:q], filters: filter_params, page: params[:page]).videos
              else
                Video.visible.includes(playlist: :topic).order(published_at: :desc).page(params[:page]).per(10)
              end
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    authenticate_user! if @video.scheduled? && @video.private
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end

  def find_by_id
    @video = Video.find_by!(youtube_id: params[:id])
    redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
  end

  private

  def filter_params
    params.permit(:q, :length, :tag, topic: [])
  end
end
