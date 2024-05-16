# frozen_string_literal: true

module Dashboard
  class TopicsController < Dashboard::DashboardController
    before_action :topic_set, only: %i[show edit update destroy order reorder]

    def index
      @topics = Topic.order(updated_at: :desc).page(params[:page])
    end

    def show; end

    def order
      @playlists = Playlist.where(topic_id: @topic.id).order(topic_position: :asc)
    end

    def new
      @topic = Topic.new
    end

    def edit; end

    def create
      @topic = Topic.new(topic_params)
      if @topic.save
        redirect_to [:dashboard, @topic], notice: t('.created')
      else
        render :new
      end
    end

    def update
      if @topic.update(topic_params)
        redirect_to [:dashboard, @topic], notice: t('.updated')
      else
        render :edit
      end
    end

    def reorder
      @playlist = @topic.playlists.find(params[:playlist])
      case params[:direction]
      when 'up'
        @playlist.move_higher
      when 'down'
        @playlist.move_lower
      end
    end

    def destroy
      @topic.destroy!
      redirect_to %i[dashboard topics], notice: t('.destroyed')
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :description, :color, :thumbnail, :forum_url, :parent_topic_id)
    end

    def topic_set
      @topic = Topic.friendly.find(params[:id] || params[:topic_id])
    end
  end
end
