class AddSynonymsTagsToTag < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :synonyms, :string, array: true, default: [], null: false
  end
end
