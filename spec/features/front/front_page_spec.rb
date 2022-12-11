# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Front page' do
  scenario 'loads successfully' do
    visit root_path
    expect(page.status_code).to be 200
  end

  scenario 'presents the project' do
    visit root_path
    expect(page).to have_text '¿Qué es makigas?'
  end

  scenario 'allows the user to navigate for topics' do
    topic = create(:topic, slug: 'mejora-tus-skills')
    visit root_path
    expect(page).to have_text topic.title
  end
end
