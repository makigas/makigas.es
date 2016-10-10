class PlaylistsController < ApplicationController
  
  def index
    @playlists = Playlist.all.order(created_at: :desc)
  end
  
  def show
    @playlist = Playlist.friendly.find(params[:id])
    if params[:id] != @playlist.slug
      redirect_to @playlist, status: 301
    end
  end
end
