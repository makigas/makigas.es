require 'rails_helper'

RSpec.feature "Dashboard", type: :feature do
  context "when not logged in" do
    it "should not be success" do
      visit dashboard_path
      expect(page.current_path).not_to eq dashboard_topics_path
    end
  end

  context "when logged in" do
    it "should be success" do
      visit dashboard_path
      expect(page.status_code).to eq 200
    end
  end
end