class VideosController < ApplicationController

  def index
    @videos = Video.all.order(created_at: :desc)
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end
  
end
