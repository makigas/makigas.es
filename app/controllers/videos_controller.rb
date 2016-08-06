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

  private

  def video_attributes
    params.require(:video).permit(:title, :description, :youtube_id,
                                  :thumbnail, :playlist_id, :position,
                                  :duration, :natural_duration)
  end
end
