class CreateCitations < ActiveRecord::Migration[7.1]
  def change
    create_table :citations do |t|
      t.string :title
      t.string :author
      t.integer :published_year
      t.string :doi
      t.integer :citations_count
      t.references :paper, null: false, foreign_key: true

      t.timestamps
    end
  end
end
