# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Front page', type: :feature do
  scenario 'loads successfully' do
    visit root_path
    expect(page.status_code).to be 200
  end

  scenario 'presents the project' do
    visit root_path
    expect(page).to have_text '¿Qué es makigas?'
  end

  scenario 'allows the user to navigate for topics' do
    visit root_path
    click_link 'Explora las temáticas'
    expect(page).to have_current_path topics_path
  end
end
