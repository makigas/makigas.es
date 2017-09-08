class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.timestamps
      t.references :video, required: true, indexed: true
      t.string :url, length: 1024, required: true
      t.string :description, length: 256, required: true
    end
  end
end
