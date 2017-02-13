class FrontController < ApplicationController
  def index
    @opinions = Opinion.limit(4)
    @recent = Video.order(created_at: :desc).limit(4)
  end
end
