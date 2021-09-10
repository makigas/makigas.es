class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.references :documentable, polymorphic: true
      t.string :type, default: nil, null: false, index: true
      t.string :language, default: nil, null: false
      t.text :content, default: '', null: true
      t.timestamps
    end
  end
end
