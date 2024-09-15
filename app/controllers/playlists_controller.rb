# frozen_string_literal: true

class PlaylistsController < ApplicationController
  before_action :playlist_set, only: %i[show]

  def index
    @playlists = Playlist.with_public_videos
                         .then { |p| filter_by_topic(p) }
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

  def filter_by_topic(playlists)
    return playlists if params[:topic].blank?

    topic = Topic.friendly.find_by(slug: params[:topic])
    return playlists if topic.blank?

    playlists.where(topic:)
  end

  def sort_content(playlists)
    case params[:sort]
    when 'popular'
      playlists.order(aggregated_views_recent: :desc)
    when 'recent'
      playlists.sort_by_latest_video
    else
      playlists.order(aggregated_views_total: :desc)
    end
  end

  def playlist_set
    @playlist = Playlist.friendly.find(params[:id])
    redirect_to @playlist, status: :moved_permanently if params[:id] != @playlist.slug
  end
end
