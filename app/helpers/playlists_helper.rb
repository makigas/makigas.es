# frozen_string_literal: true

module PlaylistsHelper
  def derive_playlists_url(filters)
    valid_filters = filters.slice(:tag, :sort)
    url_for(request.query_parameters.merge(valid_filters))
  end
end
