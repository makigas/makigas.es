# frozen_string_literal: true

module Dashboard
  class VideosController < Dashboard::DashboardController
    before_action :video_set, only: %i[show edit update destroy move]

    DEFAULT_SORT_CRITERIA = 'released'

    def index
      @sorter = VideoSorter.new(query: params[:sort] || DEFAULT_SORT_CRITERIA)
      @videos = @sorter.videos.where(filter_criteria).page(params[:page])
      @playlists = Playlist.select(:id, :title).order(:topic_id, :created_at)
    end

    def show; end

    def new
      @video = Video.new.tap do |video|
        video.playlist_id = params[:playlist_id] if params[:playlist_id].present?
      end
    end

    def edit; end

    def create
      @video = Video.new(video_params)
      if @video.save
        redirect_to (params[:return_to] || [:dashboard, @video.playlist, @video]), notice: t('.created')
      else
        render :new
      end
    end

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

    def update_slug
      @request = ModalSlug.new(update_slug_params)
      @request.update_slug!
      redirect_to [:dashboard, @request.video.playlist, @request.video], notice: t('.updated')
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
                                    :excerpt, :tags, :playlist_id, :published_at).tap do |video_params|
        video_params[:tags] = video_params[:tags].split if video_params[:tags].present?
        video_params[:user_id] = current_user.id
      end
    end

    def filter_criteria
      params.permit(:playlist_id).compact_blank
    end

    def update_slug_params
      params.require(:modal_slug).permit(:id, :slug, :reset)
    end
  end
end
