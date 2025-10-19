# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jsonld::User::AuthorBlueprint do
  let(:user) { create(:user, name: 'John Doe') }

  describe 'default view' do
    subject(:schema) { described_class.render_as_hash(user, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/users/#{user.id}#author"
      }
    end

    it { is_expected.to match(shape) }
  end

  describe 'extended view' do
    subject(:schema) { described_class.render_as_hash(user, view: :full, host: 'https://www.makigas.es') }

    let(:shape) do
      {
        '@id' => "https://www.makigas.es/users/#{user.id}#author",
        '@type' => 'Person',
        'name' => user.name
      }
    end

    it { is_expected.to match(shape) }

    context 'when the user has set an URL' do
      before do
        user.update(external_url: 'https://www.example.com/~john')
      end

      let(:shape) do
        {
          '@id' => "https://www.makigas.es/users/#{user.id}#author",
          '@type' => 'Person',
          'name' => user.name,
          'url' => 'https://www.example.com/~john'
        }
      end

      it { is_expected.to match(shape) }
    end
  end
end
