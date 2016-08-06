class VideosController < ApplicationController

  def index
    @videos = Video.all.order(created_at: :desc)
  end

  def show
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    @in_playlist = @video.higher_items(5) + [@video] + @video.lower_items(5)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_attributes)
    if @video.save
      redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
    else
      render :new
    end
  end

  def edit
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
  end

  def update
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    if @video.update_attributes(video_attributes)
      redirect_to playlist_video_path(@video, playlist_id: @video.playlist)
    else
      render :edit
    end
  end

  def destroy
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
    if @video.destroy
      redirect_to playlist_path(@playlist)
    else
      # TODO: Something should be actually done.
      redirect_to video_playlist_path(@video, playlist_id: @playlist)
    end
  end

  private

  def video_attributes
    params.require(:video).permit(:title, :description, :youtube_id,
                                  :thumbnail, :playlist_id, :position,
                                  :duration, :natural_duration)
  end
end
