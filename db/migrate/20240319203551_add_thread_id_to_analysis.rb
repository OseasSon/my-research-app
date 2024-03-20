class AddThreadIdToAnalysis < ActiveRecord::Migration[7.1]
  def change
    add_column :analyses, :thread_id, :string
  end
end
