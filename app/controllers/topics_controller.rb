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

  def edit
    @topic = Topic.friendly.find(params[:id])
  end

  def update
    @topic = Topic.friendly.find(params[:id])
    if @topic.update_attributes(topic_attributes)
      redirect_to topic_path(@topic)
    else
      render :edit
    end
  end

  def destroy
    @topic = Topic.friendly.find(params[:id])
    if @topic.destroy
      redirect_to topics_path
    else
      redirect_to topic_path(@topic)
    end
  end

  def insert
    @topic = Topic.friendly.find(params[:id])
    @playlists = Playlist.where(topic: nil)
  end

  def do_insert
    @topic = Topic.friendly.find(params[:id])
    @playlist = Playlist.find(params[:playlist])
    if @playlist.update_attribute(:topic, @topic)
      redirect_to topic_path(@topic)
    else
      redirect_to insert_topic_path(@topic)
    end
  end

  def release
    @topic = Topic.friendly.find(params[:id])
    @playlist = Playlist.find(params[:playlist])
    if @playlist.update_attribute(:topic, nil)
      redirect_to topic_path(@topic)
    else
      redirect_to topic_path(@topic)
    end
  end

  private

  def topic_attributes
    params.require(:topic).permit(:title, :description, :photo)
  end
end
