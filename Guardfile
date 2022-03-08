# frozen_string_literal: true

guard 'rails' do
  # Reload the Ruby on Rails application when these files are touched.
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})

  # TODO: Sometimes touching a component preview causes Lookbook to fail.
  # Should I just reload the application when spec/components/previews
  # is updated?
end

guard 'rspec', cmd: 'bundle exec rspec' do
  # When these core files are modified, everything has to be run again.
  watch('spec/spec_helper.rb') { 'spec' }
  watch('spec/rails_helper.rb') { 'spec' }

  # When a spec is modified, it is run automatically.
  watch(%r{^spec/.+_spec.rb$})

  # When a factory is modified, run the entire RSpec
  watch(%r{^spec/factories/(.+)\.rb$}) { 'spec' }

  # For things in app and lib, test if the alternate file is modified.
  # This will work for the lib/ directory and for some directories such as
  # app/models, app/helpers and app/components.
  watch(%r{^app/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }

  # Some root things
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch('app/models/application_record.rb') { 'spec/models' }

  # Then for features we listen for controllers and views and run the
  # feature tests appropiately when these files are modified. Note that
  # because I do not guarantee that my feature tests have the actions
  # as file names, I'll just test the entire directory.
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| "spec/features/#{m[1]}" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) { |m| "spec/features/#{m[1]}" }
end

guard 'rubocop', all_on_start: false do
  watch(/.+\.rb$/) { |m| m[0] }
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  watch(%r{(?:.+/)?\.rubocop_todo\.yml$}) { |m| File.dirname(m[0]) }
end
