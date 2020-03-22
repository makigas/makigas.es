class VideosController < ApplicationController
  def index
    @videos = Video.visible.joins(:playlist).all
    if params[:length]
      @videos = @videos.where('duration <= 300') if params[:length] == 'short'
      @videos = @videos.where('duration > 300 and duration <= 900') if params[:length] == 'medium'
      @videos = @videos.where('duration > 900') if params[:length] == 'long'
    end
    @videos = @videos.where(playlists: { topic_id: Topic.where(slug: params[:topic]).pluck(:id) }) if params[:topic]
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
end
