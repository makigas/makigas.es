require 'rails_helper'

RSpec.feature "Home", type: :feature do
  it 'should be success' do
    visit root_path
    expect(page).to have_http_status(200)
  end
  
  it 'should greet the user' do
    visit root_path
    expect(page).to have_content('En esto tan simple consiste makigas')
  end
end
