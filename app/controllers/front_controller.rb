class FrontController < ApplicationController
  def index
    @opinions = Opinion.limit(4)
    @recent = Video.where(unfeatured: false).order(created_at: :desc).limit(4)
  end
end
