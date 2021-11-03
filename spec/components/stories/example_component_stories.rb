# frozen_string_literal: true

class ExampleComponentStories < ViewComponent::Storybook::Stories
  layout 'storybook'

  story :hello_world do
    constructor(title: 'Hola buenos dias')
  end
end
