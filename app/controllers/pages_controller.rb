# frozen_string_literal: true

class PagesController < ApplicationController
  layout('six/pages') if ENV['USE_SIX'].present?
end
