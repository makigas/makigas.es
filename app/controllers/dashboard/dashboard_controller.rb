# frozen_string_literal: true

module Dashboard
  class DashboardController < ApplicationController
    before_action :authenticate_user!

    layout('dashboard/dashboard')

    def index
      @videos = Video.count
      @playlists = Playlist.count
      @users = User.count
      @tags = Tag.count
      @statistics = fetch_statistics
    end

    private

    def fetch_statistics
      Plausible::Integration.last_30_days(compare: true)
    rescue Net::HTTPError
      nil
    end
  end
end
