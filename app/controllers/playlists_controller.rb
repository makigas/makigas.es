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

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(playlist_attributes)
    if @playlist.save
      redirect_to playlist_path(@playlist)
    else
      render :new
    end
  end

  def edit
    @playlist = Playlist.friendly.find(params[:id])
  end

  def update
    @playlist = Playlist.friendly.find(params[:id])
    if @playlist.update_attributes(playlist_attributes)
      redirect_to playlist_path(@playlist)
    else
      render :edit
    end
  end

  def destroy
    @playlist = Playlist.friendly.find(params[:id])
    if @playlist.destroy
      redirect_to playlists_path, notice: 'Borrado con éxito'
    else
      raise Errors::UnprocessableEntity
    end
  end

  private

  def playlist_attributes
    params.require(:playlist).permit(:title, :description, :youtube_id, :photo)
  end
  
end
