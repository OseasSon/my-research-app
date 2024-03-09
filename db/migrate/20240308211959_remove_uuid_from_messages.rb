class RemoveUuidFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :uuid, :integer
  end
end
