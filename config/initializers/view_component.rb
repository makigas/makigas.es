# frozen_string_literal: true

# Configure ViewComponent preview paths.
unless Rails.env.production?
  Rails.application.config.view_component.previews.default_layout = 'component_preview'
  Rails.application.config.view_component.previews.paths = [Rails.root.join('spec/components/previews')]
end
