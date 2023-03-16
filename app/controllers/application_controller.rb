# frozen_string_literal: true

class ApplicationController < ActionController::Base
  after_action :disable_session_cookie

  private

  def disable_session_cookie
    return if warden.user.present? || request.subdomain == 'dashboard'

    request.session_options[:skip] = true
  end
end
