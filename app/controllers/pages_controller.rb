# frozen_string_literal: true

class PagesController < ApplicationController
  def discord
    return unless params.keys.include?('go')

    discord_url = "https://discord.gg/#{Rails.application.secrets.discord_server_invite}"
    redirect_to discord_url, status: :found, allow_other_host: true
  end
end
