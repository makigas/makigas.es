# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard topics', type: :feature do
  let(:playlist) { FactoryBot.create(:playlist) }
  let!(:topic) { FactoryBot.create(:topic, playlists: [playlist]) }

  before { Capybara.default_host = 'http://dashboard.example.com' }

  after { Capybara.default_host = 'http://www.example.com' }

  context 'when not logged in' do
    it 'is not success' do
      visit dashboard_topics_path
      expect(page).to have_no_current_path dashboard_topics_path
    end
  end

  context 'when logged in' do
    let(:user) { FactoryBot.create(:user) }

    before do
      login_as user, scope: :user
    end

    it 'user can list the topics' do
      visit dashboard_topics_path
      expect(page).to have_link topic.title, href: dashboard_topic_path(topic)
      within(:xpath, "//tr[.//td//a[text() = '#{topic.title}']]") do
        expect(page).to have_xpath '//td', text: topic.playlists.count
      end
    end

    it 'user can create topics' do
      visit dashboard_topics_path
      click_link 'Nuevo Tema'

      expect do
        fill_in 'Título', with: 'My Topic'
        fill_in 'Descripción', with: 'This is a featured topic for the website'
        fill_in 'Color', with: '#ff0000'
        attach_file 'Miniatura', Rails.root.join('spec/fixtures/topic.png')
        click_button 'Crear Tema'
      end.to change(Topic, :count).by 1

      expect(page).to have_text 'Tema creado correctamente'
    end

    it 'user can edit topics' do
      visit dashboard_topics_path
      within(:xpath, "//tr[.//td//a[text() = '#{topic.title}']]") do
        click_link 'Editar'
      end
      fill_in 'Título', with: 'My new title'
      click_button 'Actualizar Tema'

      expect(page).to have_text 'Tema actualizado correctamente'
      topic.reload
      expect(topic.title).to eq 'My new title'
    end

    it 'user can destroy topics' do
      visit dashboard_topics_path
      expect do
        within(:xpath, "//tr[.//td//a[text() = '#{topic.title}']]") do
          click_button 'Destruir'
        end
      end.to change(Topic, :count).by(-1)

      expect(page).to have_text 'Tema eliminado correctamente'
    end

    it 'user cannot create invalid topics' do
      visit dashboard_topics_path
      click_link 'Nuevo Tema'
      expect do
        fill_in 'Descripción', with: 'This is a featured topic for the website'
        fill_in 'Color', with: '#ff0000'
        attach_file 'Miniatura', Rails.root.join('spec/fixtures/topic.png')
        click_button 'Crear Tema'
      end.not_to change(Topic, :count)

      expect(page).not_to have_text 'Tema creado correctamente'
    end
  end
end
