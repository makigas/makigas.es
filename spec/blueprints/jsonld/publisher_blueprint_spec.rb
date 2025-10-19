# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::PublisherBlueprint do
  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(nil, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => 'https://www.makigas.es/#publisher'
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(nil, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => 'https://www.makigas.es/#publisher',
        '@type' => 'Organization',
        'name' => 'Makigas',
        'url' => 'https://www.makigas.es'
      }
    end

    it { is_expected.to match(shape) }
  end
end
