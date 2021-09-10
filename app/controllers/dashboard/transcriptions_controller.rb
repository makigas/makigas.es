class Dashboard::TranscriptionsController < Dashboard::DashboardController
  before_action :set_video

  def show
    @transcription = Transcription.find_or_initialize_by(documentable: @video)
  end

  def create
    @transcription = Transcription.find_or_initialize_by(documentable: @video)
    if @transcription.update(transcription_params)
      redirect_to [:dashboard, @playlist, @video]
    else
      render :show
    end
  end

  def update
    @transcription = Transcription.find_or_initialize_by(documentable: @video)
    if @transcription.update(transcription_params)
      redirect_to [:dashboard, @playlist, @video]
    else
      render :show
    end
  end

  def destroy
    @transcription = Transcription.find_by(documentable: @video)
    @transcription.destroy if @transcription.present?
    redirect_to [:dashboard, @playlist, @video]
  end

  private

  def transcription_params
    params.require(:transcription).permit(:language, :content)
  end

  def set_video
    @playlist = Playlist.friendly.find(params[:playlist_id])
    @video = @playlist.videos.find_by!(slug: params[:video_id])
  end
end
