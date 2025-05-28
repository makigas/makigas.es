# frozen_string_literal: true

class PlaylistsController < ApplicationController
  before_action :playlist_set, only: %i[show]

  def index
    @playlists = Playlist.with_public_videos
                         .then { |p| filter_by_tag(p) }
                         .then { |p| sort_content(p) }
                         .page(params[:page]).per(12)
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

  def filter_by_tag(playlists)
    return playlists if params[:tag].blank?

    playlist_id = Video.filter_by_tag(params[:tag]).pluck(:playlist_id)
    return playlists if playlist_id.blank?

    playlists.where(id: playlist_id)
  end

  def sort_content(playlists)
    case params[:sort]
    when 'popular'
      playlists.order(normalized_views_recent: :desc)
    when 'recent'
      playlists.sort_by_latest_video
    else
      playlists.order(normalized_views_total: :desc)
    end
  end

  def playlist_set
    @playlist = Playlist.friendly.find(params[:id])
    redirect_to @playlist, status: :moved_permanently if params[:id] != @playlist.slug
  end
end
