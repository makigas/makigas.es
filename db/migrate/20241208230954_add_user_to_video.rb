# frozen_string_literal: true

class AddUserToVideo < ActiveRecord::Migration[7.2]
  def change
    add_reference :videos, :user, index: true, null: true
  end
end
