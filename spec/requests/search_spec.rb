# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search' do
  before do
    allow(Tag).to receive(:deploy_synonyms)
    allow(Meilisearch::Rails).to receive(:federated_search).and_return(double(hits: []))
  end

  it 'renders a removable filter for an unknown tag' do
    get search_path(tag: 'unknown-topic', q: 'ruby')

    page = Capybara.string(response.body)
    aggregate_failures do
      expect(response).to have_http_status(:ok)
      expect(page).to have_css('.SearchFilter', text: 'Tema: unknown-topic')
      expect(page).to have_css('.SearchFilter a[href="/explorar?q=ruby"]')
      expect(page).to have_text('No se han encontrado resultados')
    end
  end

  it 'uses the title for an existing tag' do
    tag = create(:tag, slug: 'git')

    get search_path(tag: tag.slug)

    aggregate_failures do
      expect(response).to have_http_status(:ok)
      expect(Capybara.string(response.body)).to have_css('.SearchFilter', text: "Tema: #{tag.title}")
    end
  end
end
