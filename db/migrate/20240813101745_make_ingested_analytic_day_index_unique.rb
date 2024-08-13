# frozen_string_literal: true

class MakeIngestedAnalyticDayIndexUnique < ActiveRecord::Migration[7.0]
  def change
    remove_index :ingested_analytics, :day
    add_index :ingested_analytics, [:day], unique: true
  end
end
