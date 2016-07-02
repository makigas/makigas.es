class VideosController < ApplicationController
  
  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end
end
