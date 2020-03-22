# frozen_string_literal: true

module Dashboard
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
      @videos = Video.count
      @playlists = Playlist.count
      @topics = Topic.count
      @users = User.count
      @opinions = Opinion.count
    end
  end
end
