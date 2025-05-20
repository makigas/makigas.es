# frozen_string_literal: true

module Dashboard
  class TipsController < Dashboard::DashboardController
    before_action :tip_assign, only: %i[show edit update destroy]

    def index
      @tips = Tip.includes(:taxonomy).order(updated_at: :desc).page(params[:page])
    end

    def show; end

    def new
      @tip = Tip.new
      @tags = Tag.all
    end

    def edit; end

    def create
      @tip = Tip.new(user_id: current_user.id, **tip_params)
      if @tip.save
        redirect_to dashboard_tip_path(@tip.id), notice: t('.created')
      else
        render :new
      end
    end

    def update
      if @tip.update(tip_params)
        redirect_to dashboard_tip_path(@tip.id), notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      @tip.delete!
      redirect_to dashboard_tips_path, notice: t('.destroyed')
    end

    private

    def tip_params
      params.require(:tip).permit(:title, :description, :content, :taxonomy_id, :youtube_id, :published_at, :status,
                                  :tags).tap do |params|
        params[:tags] = params[:tags].split if params[:tags].present?
      end
    end

    def tip_assign
      @tip = Tip.find(params[:id])
    end
  end
end
