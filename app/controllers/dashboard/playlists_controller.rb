class Dashboard::PlaylistsController < ApplicationController

  before_action :playlist_set, only: [:show, :edit, :update, :destroy]

  def index
    @playlists = Playlist.all
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(playlist_params)
    if @playlist.save
      redirect_to [:dashboard, @playlist], notice: t('.created')
    else
      render :new
    end
  end

  def update
    if @playlist.update_attributes(playlist_params)
      redirect_to [:dashboard, @playlist], notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @playlist.destroy!
    redirect_to [:dashboard, :playlists], notice: t('.destroyed')
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description, :youtube_id, :topic_id)
  end

  def playlist_set
    @playlist = Playlist.friendly.find(params[:id])
  end

end
