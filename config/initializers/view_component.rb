# frozen_string_literal: true

# Configure ViewComponent preview paths.
Rails.application.config.view_component.default_preview_layout = 'component_preview'
Rails.application.config.view_component.preview_paths = [Rails.root.join('spec/components/previews')]
