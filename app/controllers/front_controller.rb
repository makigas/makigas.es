# frozen_string_literal: true

class FrontController < ApplicationController
  def index
    @recent = Video.visible.order(created_at: :desc).limit(4)
  end
end
