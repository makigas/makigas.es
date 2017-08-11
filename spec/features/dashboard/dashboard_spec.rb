require 'rails_helper'

RSpec.feature "Dashboard", type: :feature do
  before { Capybara.default_host = "http://dashboard.example.com" }
  after { Capybara.default_host = "http://www.example.com" }

  context "when not logged in" do
    it "should not be success" do
      visit root_path
      expect(page.current_path).not_to eq topics_path
    end
  end

  context "when logged in" do
    it "should be success" do
      visit root_path
      expect(page.status_code).to eq 200
    end
  end
end