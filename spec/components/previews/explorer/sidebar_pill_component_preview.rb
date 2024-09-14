# frozen_string_literal: true

module Explorer
  class SidebarPillComponentPreview < Lookbook::Preview
    # Search pill
    # -----------
    # Search pills can be used in explorer pages, such as the list of videos or the list
    # of playlists, in order to provide a faceted search that allows to limit the content
    # that is visible to a subset of the elements matching a specific pattern or criteria.
    #
    # @param title text "The title to present inside the preview"
    # @param active toggle "Whether to mark the pill as active or not"
    # @param icon_before text "The icon to display before the text node"
    # @param icon_after text "The icon to display after the text node"
    # @param force_pad_left toggle "Vertically align text if no left icon is present"
    #
    # @display wrapper true
    # @display max_width 320px
    def playground(title: 'Trending', active: false, icon_before: nil, icon_after: 'x', force_pad_left: false)
      render Explorer::SidebarPillComponent.new(title:, url: '#', active:, icon_before:, icon_after:, force_pad_left:)
    end
  end
end
