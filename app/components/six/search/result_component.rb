# frozen_string_literal: true

module Six
  module Search
    # The result component is used to present information about a video in the
    # search page. Most notably, this component will be used with the collection
    # parameter in order to paint a list of results.
    #
    # This is a molecule component that will present inner components for
    # additional metadata such as a link to the playlist and the topic itself,
    # and links to filter videos by tag.
    class ResultComponent < ViewComponent::Base
      with_collection_parameter :video

      # Create a new result component.
      # @param video [Video] the video to include in the results
      def initialize(video: nil)
        super
        @video = video
      end

      private

      attr_reader :video

      delegate :playlist, to: :video
      delegate :topic, to: :playlist
    end
  end
end
