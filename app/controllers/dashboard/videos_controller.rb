class Dashboard::VideosController < ApplicationController

  before_action :video_set, only: [:show, :edit, :update, :destroy]

  def index
    @videos = Video.order(created_at: :desc)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to [:dashboard, @video.playlist, @video], notice: t('.created')
    else
      render :new
    end
  end

  def update
    if @video.update_attributes(video_params)
      redirect_to [:dashboard, @video.playlist, @video], notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @video.destroy!
    redirect_to [:dashboard, :videos], notice: t('.destroyed')
  end

  private

  def video_set
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.friendly.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :description, :youtube_id, :duration, :playlist_id, :created_at)
  end

end
