# frozen_string_literal: true

module Six
  module Search
    # The box component is a panel presented in the sidebar of the search page
    # in order to group multiple filters in a section. For instance, to group
    # all the tag filters or all the duration filters, a box would be used
    # to render the associated pills.
    class BoxComponent < ViewComponent::Base
      renders_one :title
      renders_many :pills, Six::Search::PillComponent
    end
  end
end
