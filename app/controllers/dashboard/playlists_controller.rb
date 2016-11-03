class Dashboard::PlaylistsController < Dashboard::DashboardController

  before_action :locate_playlist, only: [:edit, :show, :update, :destroy]

  def index
    @playlists = Playlist.all.page(params[:page]).per(10)
  end

  def new
    @playlist = Playlist.new
  end

  def show
    render json: @playlist
  end

  def create
    @playlist = Playlist.new(playlist_params)
    if @playlist.save
      redirect_to [:dashboard, @playlist]
    else
      render :new
    end
  end

  def update
    if @playlist.update_attributes(playlist_params)
      redirect_to [:dashboard, @playlist]
    else
      render :edit
    end
  end

  def destroy
    @playlist.destroy!
    redirect_to [:dashboard, :playlists]
  end

  private

  def locate_playlist
    @playlist = Playlist.friendly.find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:title, :description, :youtube_id, :photo, :topic_id)
  end

end
