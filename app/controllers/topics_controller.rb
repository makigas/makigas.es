class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.friendly.find(params[:id])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_attributes)
    if @topic.save
      redirect_to topic_path(@topic)
    else
      render :new
    end
  end

  private

  def topic_attributes
    params.require(:topic).permit(:title, :description, :photo)
  end
end
