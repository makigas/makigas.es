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
end
