class Dashboard::DashboardController < ApplicationController

  def index
    @videos = Video.count
    @playlists = Playlist.count
    @topics = Topic.count
    @users = User.count
    @opinions = Opinion.count
  end

end
