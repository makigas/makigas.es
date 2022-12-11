# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Topics page' do
  context 'when there are no topics' do
    it 'is success' do
      visit topics_path
      expect(page.status_code).to be 200
    end
  end

  context 'when there are topics' do
    let!(:topic) { create(:topic) }

    it 'is success' do
      visit topics_path
      expect(page.status_code).to be 200
    end

    it 'shows the topics' do
      visit topics_path
      expect(page).to have_text topic.title
    end

    it 'describes the topics' do
      visit topics_path
      expect(page).to have_text topic.description
    end

    it 'shows the topic photo' do
      visit topics_path
      expect(page).to have_css "img[src*='#{topic.thumbnail.url(:small)}']"
    end

    it 'links to a topic' do
      visit topics_path
      expect(page).to have_link topic.title, href: topic_path(topic)
    end
  end
end
