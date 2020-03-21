module Dashboard
  class VideosController < Dashboard::DashboardController
    before_action :video_set, only: %i[show edit update destroy move]

    def index
      @videos = Video.order(created_at: :desc).page(params[:page])
    end

    def show; end

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
      respond_to do |format|
        if params[:direction] == "up"
          @video.move_higher
          format.json { render json: { position: @video.position, direction: "up" } }
          format.html { redirect_to [:videos, :dashboard, @video.playlist], notice: t('.moved') }
        elsif params[:direction] == "down"
          @video.move_lower
          format.json { render json: { position: @video.position, direction: "down" } }
          format.html { redirect_to [:videos, :dashboard, @video.playlist], notice: t('.moved') }
        end
      end
    end

    private

    def video_set
      @playlist = Playlist.friendly.find(params[:playlist_id])
      @video = @playlist.videos.friendly.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:title, :description, :youtube_id, :duration, :playlist_id, :unfeatured, :published_at)
    end
  end
end
