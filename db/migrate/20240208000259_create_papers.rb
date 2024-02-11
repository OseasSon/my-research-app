class CreatePapers < ActiveRecord::Migration[7.1]
  def change
    create_table :papers do |t|
      t.string :title
      t.string :author
      t.integer :published_year
      t.string :doi
      t.integer :size
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
