class Dashboard::OpinionsController < Dashboard::DashboardController

  before_action :opinion_set, only: [:show, :edit, :update, :destroy]

  def index
    @opinions = Opinion.order(updated_at: :desc).page(params[:page])
  end

  def new
    @opinion = Opinion.new
  end

  def create
    @opinion = Opinion.new(opinion_params)
    if @opinion.save
      redirect_to [:dashboard, :opinions], notice: t('.created')
    else
      render :new
    end
  end

  def update
    if @opinion.update(opinion_params)
      redirect_to [:dashboard, :opinions], notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @opinion.destroy!
    redirect_to [:dashboard, :opinions], notice: t('.destroyed')
  end

  private

  def opinion_params
    params.require(:opinion).permit(:from, :message, :url, :photo)
  end

  def opinion_set
    @opinion = Opinion.find(params[:id])
  end

end
