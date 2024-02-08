class CreateGraphs < ActiveRecord::Migration[7.1]
  def change
    create_table :graphs do |t|
      t.references :citation, null: false, foreign_key: true
      t.references :paper, null: false, foreign_key: true

      t.timestamps
    end
  end
end
