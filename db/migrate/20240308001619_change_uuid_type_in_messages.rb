class ChangeUuidTypeInMessages < ActiveRecord::Migration[7.1]
  def up
    change_column :messages, :uuid, 'integer USING CAST(uuid AS integer)'
  end

  def down
    change_column :messages, :uuid, :string
  end
end
