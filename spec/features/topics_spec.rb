require 'rails_helper'

RSpec.feature "Topics", type: :feature do
  context 'listing topics' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
    end

    it 'should be success' do
      visit topics_path
      expect(page).to have_http_status :success
    end
    
    it 'should list playlists title' do
      visit topics_path
      expect(page).to have_content @topic.title
    end
  end

  context 'creating a topic' do
    it 'should be success' do
      visit new_topic_path
      expect(page).to have_http_status :success
    end

    it 'should be able to insert data' do
      visit topics_path
      click_link I18n.t('topics.index.new')
      fill_in Topic.human_attribute_name(:title), with: 'My sample topic'
      fill_in Topic.human_attribute_name(:description), with: 'This topic is an example to test the feature'
      attach_file I18n.t('topics.form.search'), Rails.root + 'spec/fixtures/topic.jpg', visible: false
      click_button I18n.t('topics.form.save')
      expect(page).to have_content 'My sample topic'
    end

    it 'should detect invalid data' do
      visit new_topic_path
      fill_in Topic.human_attribute_name(:description), with: 'Look, no title!'
      click_button I18n.t('topics.form.save')
      expect(page).to have_content I18n.t('topics.form.errors')
    end
  end

  context 'adding a topic to a playlist' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist_on = FactoryGirl.create(:playlist, topic: @topic)
      @playlist_off = FactoryGirl.create(:playlist, topic: nil)
    end

    it 'should have a valid view' do
      visit insert_topic_path(@topic)
      expect(page).to have_http_status :success
    end

    it 'should have a valid workflow' do
      visit topic_path(@topic)
      click_link I18n.t('topics.show.insert_list')
      select @playlist_off.title, from: I18n.t('topics.insert.playlist')
      click_button I18n.t('topics.insert.insert')
      expect(page).to have_content @topic.title
      expect(page).to have_content @playlist_off.title
    end

    it 'should not suggest playlists already in a playlist' do
      visit insert_topic_path(@topic)
      expect(page).to have_select I18n.t('topics.insert.playlist'), options: [@playlist_off.title]
    end
  end

  context 'removing a playlist from a topic' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlist = FactoryGirl.create(:playlist, topic: @topic)
    end

    it 'should have a valid workflow' do
      visit topic_path(@topic)
      click_button I18n.t('topics.show.remove_list')
      expect(page).to have_content @topic.title
      expect(page).not_to have_content @playlist.title
    end
  end
end
