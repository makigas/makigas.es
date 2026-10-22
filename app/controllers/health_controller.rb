# frozen_string_literal: true

class HealthController < ApplicationController
  class HealthCheckError < StandardError; end

  before_action -> { expires_now }
  rescue_from StandardError, with: :render_ko

  def show
    raise HealthCheckError, 'The database has no videos' unless Video.exists?

    index = Meilisearch::Rails.client.index(Video.index_uid)
    raise HealthCheckError, 'The video index has no documents' unless index.number_of_documents.positive?

    render plain: 'OK'
  end

  private

  def render_ko(exception)
    Rails.logger.error("[health] #{exception.class}: #{exception.message}")
    render plain: 'KO', status: :internal_server_error
  end
end
