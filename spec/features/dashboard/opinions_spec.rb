require 'rails_helper'

RSpec.feature "Dashboard opinions", type: :feature do
  before { Capybara.default_host = "http://dashboard.example.com" }

  after { Capybara.default_host = "http://www.example.com" }

  context "when not logged in" do
    it "is not success" do
      visit dashboard_opinions_path
      expect(page).to have_no_current_path dashboard_topics_path
    end
  end

  context "when logged in" do
    before {
      @user = FactoryBot.create(:user)
      login_as @user, scope: :user
    }

    scenario "user can list the opinions" do
      @opinion = FactoryBot.create(:opinion)
      visit dashboard_opinions_path
      expect(page).to have_link @opinion.from, href: dashboard_opinion_path(@opinion)
    end

    scenario "user can create opinions" do
      visit dashboard_opinions_path
      click_link "Nueva Opinión"

      expect {
        fill_in "De", with: "Programming and Co"
        fill_in "Mensaje", with: "Este es el texto de la opinión"
        fill_in "URL", with: "https://www.example.com"
        attach_file "Imagen", Rails.root.join('spec/fixtures/opinion.png')
        click_button "Crear Opinión"
      }.to change(Opinion, :count).by 1

      expect(page).to have_text "Opinión creada correctamente"
    end

    scenario "user can edit opinions" do
      @opinion = FactoryBot.create(:opinion, from: "Programming n Co")

      visit dashboard_opinions_path
      within(:xpath, "//tr[.//td//a[text() = 'Programming n Co']]") do
        click_link "Editar"
      end
      fill_in "De", with: "Programming and Co."
      click_button "Actualizar Opinión"

      expect(page).to have_text "Opinión actualizada correctamente"
      @opinion.reload
      expect(@opinion.from).to eq 'Programming and Co.'
    end

    scenario "user can destroy opinions" do
      @opinion = FactoryBot.create(:opinion)

      visit dashboard_opinions_path
      expect {
        within(:xpath, "//tr[.//td//a[text() = '#{@opinion.from}']]") do
          click_button "Destruir"
        end
      }.to change(Opinion, :count).by(-1)

      expect(page).to have_text "Opinión destruida correctamente"
    end

    scenario "user cannot create invalid opinion" do
      visit dashboard_opinions_path
      click_link "Nueva Opinión"
      expect {
        fill_in "De", with: "Programming and Co"
        fill_in "URL", with: "https://www.example.com"
        attach_file "Imagen", Rails.root.join('spec/fixtures/opinion.png')
        click_button "Crear Opinión"
      }.not_to change(Topic, :count)

      expect(page).not_to have_text "Opinión creada correctamente"
    end
  end
end
