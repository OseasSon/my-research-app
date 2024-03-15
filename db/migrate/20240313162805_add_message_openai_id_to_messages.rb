class AddMessageOpenaiIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :message_openai_id, :string
  end
end
