# frozen_string_literal: true

module Dashboard
  class LinksController < Dashboard::DashboardController
    before_action :video_set

    def index
      @links = @video.links.page(params[:page])
    end

    def new
      @link = @video.links.build
    end

    def edit
      @link = @video.links.find(params[:id])
    end

    def create
      @link = @video.links.build(link_params)
      if @link.save
        redirect_to [:dashboard, @playlist, @video, :links], notice: t('.created')
      else
        render :new
      end
    end

    def update
      @link = @video.links.find(params[:id])
      if @link.update(link_params)
        redirect_to [:dashboard, @playlist, @video, :links], notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      @link = @video.links.find(params[:id])
      if @link.destroy
        redirect_to [:dashboard, @playlist, @video, :links], notice: t('.destroyed')
      else
        redirect_to [:dashboard, @playlist, @video, :links], error: t('.error')
      end
    end

    private

    def link_params
      params.require(:link).permit(:name, :description, :url)
    end

    def video_set
      @playlist = Playlist.friendly.find(params[:playlist_id])
      @video = Video.friendly.find(params[:video_id])
    end
  end
end
