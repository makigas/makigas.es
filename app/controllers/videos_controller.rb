# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @videos = Video.visible.free_filter(filter_params).joins(:playlist)
                   .order(published_at: :desc).page(params[:page]).per(10)
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

  def filter_params
    params.permit(:length, tag: [], topic: [])
  end
end
