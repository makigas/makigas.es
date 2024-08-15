# frozen_string_literal: true

module Dashboard
  class TagsController < Dashboard::DashboardController
    before_action :tag_assign, only: %i[edit update destroy]

    def index
      @tags = Tag.page(params[:page])
    end

    def new
      @tag = Tag.new
    end

    def edit; end

    def create
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to %i[dashboard tags], notice: t('.created')
      else
        render :new
      end
    end

    def update
      if @tag.update(tag_params)
        redirect_to %i[dashboard tags], notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      @tag.destroy
      redirect_to %i[dashboard tags], notice: t('.destroyed')
    end

    private

    def tag_assign
      @tag = Tag.find_by(slug: params[:id])
    end

    def tag_params
      params.require(:tag).permit(:title, :description, :slug, :icon, :synonyms).tap do |tag_params|
        tag_params[:synonyms] = tag_params[:synonyms].split if tag_params[:synonyms].present?
      end
    end
  end
end
