# frozen_string_literal: true

class Six::PlaylistsController < ApplicationController

  layout 'six'

  before_action :playlist_set, only: %i[show feed]

  def index
    @playlists = Playlist.sort_by_latest_video.page(params[:page]).per(12)
  end

  def show; end

  def feed
    @videos = @playlist.videos.includes(:playlist, playlist: [:topic]).visible.reverse
    @updated_at = Video.order(updated_at: :desc).limit(1).pick(:updated_at)
    render format: :xml, template: 'playlists/feed.xml.erb', layout: false
  end

  private

  def playlist_set
    @playlist = Playlist.friendly.find(params[:id])
    redirect_to @playlist, status: :moved_permanently if params[:id] != @playlist.slug
  end
end
