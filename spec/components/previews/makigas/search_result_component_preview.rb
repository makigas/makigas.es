# frozen_string_literal: true

module Makigas
  class SearchResultComponentPreview < ViewComponent::Preview
    DEFAULT_PLAYGROUND_TITLE = 'Very important lesson'

    DEFAULT_PLAYGROUND_DESCRIPTION = <<~TEXT
      A very important lesson description goes here, there are a couple of words to provide some context
      about the contents of the lesson before you try to check the contents. There is no max length, but
      the limit should stay between 50 and 100 words.
    TEXT

    # @param title text
    # @param description text
    # @param url text
    # @param label text
    # @param icon text
    # @param icon_hd text
    # @param trend select { choices: [rising, popular, none]}
    def playground(
      title: DEFAULT_PLAYGROUND_TITLE,
      description: DEFAULT_PLAYGROUND_DESCRIPTION,
      url: '#card',
      label: 'Lesson',
      icon: '/makigas.png',
      icon_hd: '/makigas.png',
      trend: 'none'
    )
      render Makigas::SearchResultComponent.new(title:, description:, url:, label:, icon:, icon_hd:, trend:)
    end
  end
end
