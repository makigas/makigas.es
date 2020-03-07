require 'rails_helper'

RSpec.feature 'Front opinions', type: :feature do
  let!(:opinion) { FactoryBot.create(:opinion) }

  scenario 'displays link' do
    visit root_path
    within('.about-opinions') do
      expect(page).to have_link opinion.from, href: opinion.url
    end
  end

  scenario 'displays description' do
    visit root_path
    within('.about-opinions') do
      expect(page).to have_text opinion.message
    end
  end

  scenario 'may not have a link' do
    opinion.update(url: nil)
    visit root_path
    within('.about-opinions') do
      expect(page).to have_text opinion.from
    end
  end
end
