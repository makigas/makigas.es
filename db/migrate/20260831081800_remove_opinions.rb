# frozen_string_literal: true

class RemoveOpinions < ActiveRecord::Migration[8.1]
  def up
    drop_table :opinions
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Opinion data was deleted'
  end
end
