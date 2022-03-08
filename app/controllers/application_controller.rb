# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout('six/six') if ENV['USE_SIX'].present?
end
