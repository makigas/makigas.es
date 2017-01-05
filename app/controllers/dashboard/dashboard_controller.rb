class Dashboard::DashboardController < ApplicationController

  def index
    @videos = Video.count
    @playlists = Playlist.count
    @topics = Topic.count
    @users = User.count
  end

end
