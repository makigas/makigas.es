# frozen_string_literal: true

class ErrorController < ApplicationController
  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end

  def unprocessable_entity
    render status: :unprocessable_entity
  end

  def not_acceptable
    render status: :not_acceptable
  end
end
