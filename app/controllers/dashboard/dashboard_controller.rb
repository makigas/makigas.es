# frozen_string_literal: true

module Dashboard
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    layout('dashboard/dashboard')

    def index
      @videos = Video.count
      @playlists = Playlist.count
      @topics = Topic.count
      @users = User.count
      @opinions = Opinion.count
      @statistics = fetch_statistics
    end

    private

    def fetch_statistics
      Plausible::Integration.last_30_days(true)
    rescue Net::HTTPError
      nil
    end
  end
end
