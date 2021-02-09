# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard opinions', type: :feature do
  before { Capybara.default_host = 'http://dashboard.example.com' }

  after { Capybara.default_host = 'http://www.example.com' }

  context 'when not logged in' do
    it 'is not success' do
      visit dashboard_opinions_path
      expect(page).to have_no_current_path dashboard_topics_path
    end
  end

  context 'when logged in' do
    let(:user) { FactoryBot.create(:user) }
    let!(:opinion) { FactoryBot.create(:opinion, from: 'Programming n Co') }

    before do
      login_as user, scope: :user
    end

    it 'user can list the opinions' do
      visit dashboard_opinions_path
      expect(page).to have_link opinion.from, href: dashboard_opinion_path(opinion)
    end

    it 'user can create opinions' do
      visit dashboard_opinions_path
      click_link 'Nueva Opinión'

      fill_in 'De', with: 'Programming and Co'
      fill_in 'Mensaje', with: 'Este es el texto de la opinión'
      fill_in 'URL', with: 'https://www.example.com'
      attach_file 'Imagen', Rails.root.join('spec/fixtures/opinion.png')
      click_button 'Crear Opinión'

      aggregate_failures do
        expect(page).to have_text 'Opinión creada correctamente'
        expect(page).to have_text 'Programming and Co'
      end
    end

    it 'user can edit opinions' do
      visit dashboard_opinions_path
      within(:xpath, "//tr[.//td//a[text() = 'Programming n Co']]") do
        click_link 'Editar'
      end
      fill_in 'De', with: 'Programming and Co.'
      click_button 'Actualizar Opinión'

      aggregate_failures do
        expect(page).to have_text 'Opinión actualizada correctamente'
        expect(page).to have_text 'Programming and Co.'
      end
    end

    it 'user can destroy opinions' do
      @opinion = FactoryBot.create(:opinion)

      visit dashboard_opinions_path
      within(:xpath, "//tr[.//td//a[text() = '#{opinion.from}']]") do
        click_button 'Destruir'
      end

      aggregate_failures do
        expect(page).to have_text 'Opinión destruida correctamente'
        expect(page).not_to have_link opinion.from
      end
    end

    it 'user cannot create invalid opinion' do
      visit dashboard_opinions_path
      click_link 'Nueva Opinión'
      fill_in 'De', with: 'Programming and Co'
      fill_in 'URL', with: 'https://www.example.com'
      attach_file 'Imagen', Rails.root.join('spec/fixtures/opinion.png')
      click_button 'Crear Opinión'

      expect(page).not_to have_text 'Opinión creada correctamente'
    end
  end
end
