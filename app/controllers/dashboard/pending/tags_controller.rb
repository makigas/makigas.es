# frozen_string_literal: true

module Dashboard
  module Pending
    class TagsController < Dashboard::DashboardController
      def show
        # We actually query for playlists that contain videos without tags.
        @playlists = Playlist.where(id: Video.untagged.distinct.select(:playlist_id))
      end

      def update
        videos = videos_to_update
        Video.update(videos.keys, videos.values)
        redirect_to action: :show
      end

      private

      def videos_to_update
        {}.tap do |index|
          update_params[:video].each do |id, params|
            valid_params = params.permit(:tags)
            valid_params[:tags] = valid_params[:tags].split.map(&:strip)
            index[id] = valid_params if valid_params.keys.all? { |k| valid_params[k].present? }
          end
        end
      end

      def update_params
        params.require(:batch).permit(video: {})
      end
    end
  end
end
