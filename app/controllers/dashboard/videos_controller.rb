# frozen_string_literal: true

module Dashboard
  class VideosController < Dashboard::DashboardController
    before_action :video_set, only: %i[show edit update destroy move]

    def index
      @videos = Video.order(created_at: :desc).page(params[:page])
    end

    def show; end

    def new
      @video = Video.new.tap do |video|
        video.playlist_id = params[:playlist_id] if params[:playlist_id].present?
      end
    end

    def create
      @video = Video.new(video_params)
      if @video.save
        redirect_to (params[:return_to] || [:dashboard, @video.playlist, @video]), notice: t('.created')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @video.update(video_params)
        redirect_to [:dashboard, @video.playlist, @video], notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      @video.destroy!
      redirect_to %i[dashboard videos], notice: t('.destroyed')
    end

    def move
      move!(@video, params[:direction])
      respond_to do |format|
        format.json { render json: { position: @video.position, direction: params[:direction] } }
        format.html { redirect_to [:videos, :dashboard, @video.playlist], notice: t('.moved') }
      end
    end

    private

    def move!(video, direction)
      case direction
      when 'up'
        video.move_higher
      when 'down'
        video.move_lower
      else
        raise 'Unsupported direction'
      end
    end

    def video_set
      @playlist = Playlist.friendly.find(params[:playlist_id])
      @video = @playlist.videos.friendly.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:title, :description, :youtube_id, :duration, :twitch_id, :early_access,
                                    :tags, :playlist_id, :published_at).tap do |video_params|
        video_params[:tags] = video_params[:tags].split if video_params[:tags].present?
      end
    end
  end
end
