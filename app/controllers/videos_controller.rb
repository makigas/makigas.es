# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @videos = Video.visible.joins(:playlist)
    @videos = search_by_length if params[:length]
    @videos = search_by_topic if params[:topic]
    @videos = @videos.order(created_at: :desc).page(params[:page]).per 10
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    authenticate_user! if @video.scheduled? && @video.private
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end

  def feed
    @videos = Video.visible.includes(:playlist, playlist: [:topic]).order(published_at: :desc).limit(15)
    @updated_at = Video.order(updated_at: :desc).limit(1).pluck(:updated_at).first
    render format: :xml, template: 'videos/feed.xml.erb', layout: false
  end

  def find_by_id
    @video = Video.find_by!(youtube_id: params[:id])
    redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
  end

  private

  def search_by_length
    case params[:length]
    when 'short'
      @videos.where('duration <= 300')
    when 'medium'
      @videos.where('duration > 300 and duration <= 900')
    when 'long'
      @videos.where('duration > 900')
    end
  end

  def search_by_topic
    @videos.where(playlists: { topic_id: Topic.where(slug: params[:topic]).pluck(:id) })
  end
end
