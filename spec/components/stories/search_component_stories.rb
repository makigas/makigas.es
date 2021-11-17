# frozen_string_literal: true

class SearchComponentStories < ViewComponent::Storybook::Stories
  layout 'storybook'

  story :default do
    constructor(query: text(''), size: select(%i[normal large], :normal))
  end
end
