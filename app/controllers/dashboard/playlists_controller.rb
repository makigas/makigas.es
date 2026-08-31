# frozen_string_literal: true

module Dashboard
  class PlaylistsController < Dashboard::DashboardController
    before_action :playlist_set, only: %i[show edit update destroy videos tags retag]

    def index
      @playlists = Playlist.order(updated_at: :desc).page(params[:page])
    end

    def show; end

    def new
      @playlist = Playlist.new
    end

    def edit; end

    def tags; end

    def retag
      videos = videos_to_retag
      Video.update(videos.keys, videos.values)
      redirect_to [:tags, :dashboard, @playlist], notice: t('.updated')
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
      if @playlist.update(playlist_params)
        redirect_to [:dashboard, @playlist], notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      @playlist.destroy!
      redirect_to %i[dashboard playlists], notice: t('.destroyed')
    end

    def videos
      @videos = @playlist.videos
    end

    private

    def playlist_params
      params.require(:playlist).permit(:title, :description, :excerpt, :youtube_id, :forum_url, :card,
                                       :thumbnail, :exclude_from_search, :deprecated, :replacement_playlist_id)
    end

    def playlist_set
      @playlist = Playlist.friendly.find(params[:id])
    end

    def videos_to_retag
      {}.tap do |index|
        params_to_retag[:video].each do |id, params|
          valid_params = params.permit(:tags)
          valid_params[:tags] = valid_params[:tags].split.map(&:strip)
          index[id] = valid_params if valid_params.keys.all? { |k| valid_params[k].present? }
        end
      end
    end

    def params_to_retag
      params.require(:tags).permit(video: {})
    end
  end
end
