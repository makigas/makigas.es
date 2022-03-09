# frozen_string_literal: true

class PagesController < ApplicationController
  layout('six/pages') if ENV['USE_SIX'].present?

  def discord
    render(layout: 'six/six') if ENV['USE_SIX'].present?
  end
end
