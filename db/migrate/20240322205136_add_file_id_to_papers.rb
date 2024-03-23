class AddFileIdToPapers < ActiveRecord::Migration[7.1]
  def change
    add_column :papers, :file_id, :string
  end
end
