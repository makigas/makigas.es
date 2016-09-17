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

  context 'sorting playlists in a topic' do
    before(:each) do
      @topic = FactoryGirl.create(:topic)
      @playlists = [
        # Use different names since that can confuse Capybara
        FactoryGirl.create(:playlist, topic: @topic, position: 1, title: 'Playlist A'),
        FactoryGirl.create(:playlist, topic: @topic, position: 2, title: 'Playlist B')
      ]
    end

    it 'should have a page for sorting contents' do
      visit topic_path(@topic)
      expect(page).to have_content I18n.t('topics.show.sort')
      click_link I18n.t('topics.show.sort')
    end

    it 'should have a valid view' do
      visit contents_topic_path(@topic)
      expect(page).to have_http_status :success
    end

    it 'should list the playlists in the sorting page' do
      visit contents_topic_path(@topic)
      expect(page).to have_content @playlists[0].title
      expect(page).to have_content @playlists[1].title
    end

    it 'should be allowed to move a playlist up' do
      visit contents_topic_path(@topic)
      within find('tr', text: @playlists[1].title) do
        click_button I18n.t('topics.contents.up')
      end
      @playlists.each { |p| p.reload }
      expect(@playlists[1].position).to eq 1
    end

    it 'should be allowed to move a playlist down' do
      visit contents_topic_path(@topic)
      within find('tr', text: @playlists[0].title) do
        click_button I18n.t('topics.contents.down')
      end
      @playlists.each { |p| p.reload }
      expect(@playlists[0].position).to eq 2
    end

    it 'should be allowed to unlink a playlist' do
      visit contents_topic_path(@topic)
      within find('tr', text: @playlists[0].title) do
        click_button I18n.t('topics.contents.unlink')
      end
      @playlists.each { |p| p.reload }
      expect(@playlists[1].position).to eq 1
      expect(@playlists[0].topic).to be nil
    end

    it 'is not possible to move higher the first playlist' do
      visit contents_topic_path(@topic)
      row = find('tr', text: @playlists[0].title)
      expect(row).not_to have_content I18n.t('topics.contents.up')
    end

    it 'is not possible to move lower the last playlist' do
      visit contents_topic_path(@topic)
      row = find('tr', text: @playlists[1].title)
      expect(row).not_to have_content I18n.t('topics.contents.down')
    end
  end
end
