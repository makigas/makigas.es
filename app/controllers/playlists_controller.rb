# frozen_string_literal: true

class PlaylistsController < ApplicationController
  before_action :playlist_set, only: %i[show]

  def index
    @playlists = Playlist.sort_by_latest_video.page(params[:page]).per(12)
  end

  def show
    respond_to do |format|
      format.any(:html, :json)
      format.atom do
        @videos = Video.visible.where(playlist_id: @playlist.id).order(published_at: :desc)
      end
    end
  end

  private

  def playlist_set
    @playlist = Playlist.friendly.find(params[:id])
    redirect_to @playlist, status: :moved_permanently if params[:id] != @playlist.slug
  end
end
