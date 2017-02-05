require 'rails_helper'

RSpec.feature "Dashboard topics", type: :feature do
  context "when not logged in" do
    it "should not be success" do
      visit dashboard_topics_path
      expect(page.current_path).not_to eq dashboard_topics_path
    end
  end

  context "when logged in" do
    before(:each) {
      @user = FactoryGirl.create(:user)
      login_as @user, scope: :user
    }

    scenario "user can list the topics" do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)

      visit dashboard_topics_path
      expect(page).to have_link @topic.title, href: dashboard_topic_path(@topic)
      within(:xpath, "//tr[.//td//a[text() = '#{@topic.title}']]") do
        expect(page).to have_xpath "//td", text: @topic.playlists.count
      end
    end

    scenario "user can create topics" do
      visit dashboard_topics_path
      click_link "Nuevo Tema"

      expect {
        fill_in "Título", with: "My Topic"
        fill_in "Descripción", with: "This is a featured topic for the website"
        fill_in "Color", with: "#ff0000"
        attach_file "Miniatura", Rails.root.join('spec/fixtures/topic.png')
        click_button "Crear Tema"
      }.to change { Topic.count }.by 1

      expect(page).to have_text "Tema creado correctamente"
    end

    scenario "user can edit topics" do
      @topic = FactoryGirl.create(:topic, title: "My old title")

      visit dashboard_topics_path
      within(:xpath, "//tr[.//td//a[text() = 'My old title']]") do
        click_link "Editar"
      end
      fill_in "Título", with: "My new title"
      click_button "Actualizar Tema"

      expect(page).to have_text "Tema actualizado correctamente"
      @topic.reload
      expect(@topic.title).to eq 'My new title'
    end

    scenario "user can destroy topics" do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
      
      visit dashboard_topics_path
      expect {
        within(:xpath, "//tr[.//td//a[text() = '#{@topic.title}']]") do
          click_button "Destruir"
        end
      }.to change { Topic.count }.by -1

      expect(page).to have_text "Tema eliminado correctamente"
    end

    scenario "user cannot create invalid topics" do
      visit dashboard_topics_path
      click_link "Nuevo Tema"
      expect {
        fill_in "Descripción", with: "This is a featured topic for the website"
        fill_in "Color", with: "#ff0000"
        attach_file "Miniatura", Rails.root.join('spec/fixtures/topic.png')
        click_button "Crear Tema"
      }.not_to change { Topic.count }

      expect(page).not_to have_text "Tema creado correctamente"
    end
  end
end