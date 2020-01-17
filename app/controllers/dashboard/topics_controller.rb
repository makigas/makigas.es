class Dashboard::TopicsController < Dashboard::DashboardController

  before_action :topic_set, only: %i[show edit update destroy]

  def index
    @topics = Topic.order(updated_at: :desc).page(params[:page])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      redirect_to [:dashboard, @topic], notice: t('.created')
    else
      render :new
    end
  end

  def update
    if @topic.update_attributes(topic_params)
      redirect_to [:dashboard, @topic], notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy!
    redirect_to %i[dashboard topics], notice: t('.destroyed')
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :description, :color, :thumbnail)
  end

  def topic_set
    @topic = Topic.friendly.find(params[:id])
  end

end
