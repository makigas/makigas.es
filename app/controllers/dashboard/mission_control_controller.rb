# frozen_string_literal: true

module Dashboard
  class MissionControlController < ApplicationController
    before_action :authenticate_user!

    layout 'dashboard/dashboard'
  end
end
