class TopicsController < ApplicationController

  before_action :topic_set, only: %i[show feed]

  def index
    @topics = Topic.all
  end

  def feed
    @videos = Video.visible.joins(:playlist).includes(:playlist, playlist: [:topic]).where(playlists: { topic: @topic }).order(published_at: :desc).limit(15)
    @updated_at = Video.order(updated_at: :desc).limit(1).pluck(:updated_at).first
    render format: :xml, template: 'topics/feed.xml.erb', layout: false
  end

  private

  def topic_set
    @topic = Topic.friendly.find(params[:id])
    redirect_to topic_path(@topic) if params[:id] != @topic.slug
  end
end
