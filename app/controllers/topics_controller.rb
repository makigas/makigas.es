# frozen_string_literal: true

class TopicsController < ApplicationController
  before_action :topic_set, only: %i[show]

  def index
    @topics = Topic.all
  end

  def show
    respond_to do |format|
      format.any(:html, :json)
      format.atom do
        @videos = Video.visible.includes(playlist: :topic)
                       .where(playlists: { topic_id: @topic.id }).order(published_at: :desc).limit(15)
      end
    end
  end

  private

  def topic_set
    @topic = Topic.friendly.find(params[:id])
    redirect_to topic_path(@topic) if params[:id] != @topic.slug
  end
end
