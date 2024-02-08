class CreateAnalyses < ActiveRecord::Migration[7.1]
  def change
    create_table :analyses do |t|
      t.string :summary_1
      t.string :summary_2
      t.string :summary_3
      t.string :summary_4
      t.references :paper, null: false, foreign_key: true

      t.timestamps
    end
  end
end
