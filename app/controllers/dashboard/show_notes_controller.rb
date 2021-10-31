# frozen_string_literal: true

module Dashboard
  class ShowNotesController < Dashboard::DashboardController
    before_action :set_video

    def show
      @show_note = ShowNote.find_or_initialize_by(documentable: @video)
    end

    def create
      @show_note = ShowNote.find_or_initialize_by(documentable: @video)
      if @show_note.update(show_note_params)
        redirect_to [:dashboard, @playlist, @video]
      else
        render :show
      end
    end

    def update
      @show_note = ShowNote.find_or_initialize_by(documentable: @video)
      if @show_note.update(show_note_params)
        redirect_to [:dashboard, @playlist, @video]
      else
        render :show
      end
    end

    def destroy
      @show_note = ShowNote.find_by(documentable: @video)
      @show_note.destroy if @show_note.present?
      redirect_to [:dashboard, @playlist, @video]
    end

    private

    def show_note_params
      params.require(:show_note).permit(:language, :content)
    end

    def set_video
      @playlist = Playlist.friendly.find(params[:playlist_id])
      @video = @playlist.videos.find_by!(slug: params[:video_id])
    end
  end
end
