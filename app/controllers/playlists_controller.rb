# frozen_string_literal: true

class PlaylistsController < ApplicationController
  before_action :playlist_set, only: %i[show feed]

  def index
    @playlists = Playlist.all.order(created_at: :desc)
  end

  def show; end

  def feed
    @videos = @playlist.videos.includes(:playlist, playlist: [:topic]).visible.reverse
    @updated_at = Video.order(updated_at: :desc).limit(1).pluck(:updated_at).first
    render format: :xml, template: 'playlists/feed.xml.erb', layout: false
  end

  private

  def playlist_set
    @playlist = Playlist.friendly.find(params[:id])
    redirect_to @playlist, status: 301 if params[:id] != @playlist.slug
  end
end
