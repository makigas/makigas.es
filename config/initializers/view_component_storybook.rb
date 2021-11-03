# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  Rails.application.config.view_component_storybook.stories_path = Rails.root.join('spec/components/stories')

  Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '/rails/stories/*', headers: :any, methods: [:get]
    end
  end
end
