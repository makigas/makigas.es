class FrontController < ApplicationController
  def index
    @recent = Video.order(created_at: :desc).limit(4)
  end
end
