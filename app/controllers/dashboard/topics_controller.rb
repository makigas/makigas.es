class Dashboard::TopicsController < Dashboard::DashboardController

  before_action :locate_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.all
  end

  def new
    @topic = Topic.new
  end

  def show
    render json: @topic
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      redirect_to [:dashboard, @topic]
    else
      render :new
    end
  end

  def update
    if @topic.update_attributes(topic_params)
      redirect_to [:dashboard, @topic]
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy!
    redirect_to [:dashboard, :topics]
  end

  private

  def locate_topic
    @topic = Topic.friendly.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :description, :photo)
  end

end
