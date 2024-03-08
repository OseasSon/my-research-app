class AddUuidToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :uuid, :integer
  end
end
