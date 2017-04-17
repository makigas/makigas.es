class VideosController < ApplicationController

  def index
    @videos = Video.visible.joins(:playlist).all
    if params[:length]
      @videos = @videos.where('duration <= 300') if params[:length] == "short"
      @videos = @videos.where('duration > 300 and duration <= 900') if params[:length] == "medium"
      @videos = @videos.where('duration > 900') if params[:length] == "long"
    end
    @videos = @videos.where(playlists: { topic_id: Topic.where(slug: params[:topic]).pluck(:id) }) if params[:topic]
    @videos = @videos.order(created_at: :desc).page(params[:page]).per 10
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    authenticate_user! if @video.scheduled?
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end
end
