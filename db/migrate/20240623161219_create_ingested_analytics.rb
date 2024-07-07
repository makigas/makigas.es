class CreateIngestedAnalytics < ActiveRecord::Migration[7.0]
  def change
    create_table :ingested_analytics do |t|
      t.timestamps
      t.date :day, null: false, index: true, unique: true
      t.jsonb :document, null: false # , index: true
    end
  end
end
