class AddAssistantIdToPapers < ActiveRecord::Migration[7.1]
  def change
    add_column :papers, :assistant_id, :string
  end
end
