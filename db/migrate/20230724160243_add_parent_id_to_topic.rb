# frozen_string_literal: true

class AddParentIdToTopic < ActiveRecord::Migration[7.0]
  def change
    add_reference :topics, :parent_topic, nullable: true, index: true
  end
end
