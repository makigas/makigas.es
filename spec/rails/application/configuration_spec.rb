# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rails::Application::Configuration do
  subject(:configuration) { Rails.application.config }

  context 'with Rails 8.0 defaults' do
    it 'preserves timezone when converting a zoned time to Time' do
      Time.use_zone('Europe/Madrid') do
        zoned_time = Time.zone.parse('2026-01-15 12:00:00')

        expect(zoned_time.to_time.utc_offset).to eq(zoned_time.utc_offset)
      end
    end

    it 'uses entity tags as the authoritative freshness condition' do
      expect(configuration.action_dispatch.strict_freshness).to be(true)
    end

    it 'limits regular expression evaluation time' do
      expect(Regexp.timeout).to eq(1)
    end
  end

  context 'with Rails 8.1 defaults' do
    let(:controller) do
      controller_class = Class.new(ApplicationController)
      controller = controller_class.new
      controller.set_request!(ActionController::TestRequest.create(controller_class))
      controller.set_response!(ActionDispatch::TestResponse.new)
      controller
    end

    it 'does not use YJIT in the local test environment' do
      expect(configuration.yjit).to be(false)
    end

    it 'raises for path-relative redirects' do
      expect { controller.redirect_to('example.com') }
        .to raise_error(ActionController::Redirecting::UnsafeRedirectError)
    end

    it 'renders HTML and JavaScript separators unescaped in JSON responses' do
      controller.render json: { key: "\u2028\u2029<>&" }

      expect(controller.response_body.join).to eq(%({"key":"\u2028\u2029<>&"}))
    end

    it 'raises when an ordered finder has no deterministic order column' do
      connection = ActiveRecord::Base.connection
      table_name = 'rails_81_orderless_records'
      connection.create_table(table_name, id: false) { |table| table.string :name }
      model = Class.new(ApplicationRecord) { self.table_name = table_name }

      expect { model.first }.to raise_error(ActiveRecord::MissingRequiredOrderError)
    ensure
      connection&.drop_table(table_name, if_exists: true)
    end

    it 'uses Ruby to track template render dependencies' do
      expect(configuration.action_view.render_tracker).to eq(:ruby)
    end

    it 'omits autocomplete from framework-generated hidden form fields' do
      expect(configuration.action_view.remove_hidden_field_autocomplete).to be(true)
    end

    it 'renders framework-generated hidden form fields without autocomplete' do
      controller = ApplicationController.new

      expect(controller.view_context.send(:token_tag)).not_to include('autocomplete')
    end
  end
end
