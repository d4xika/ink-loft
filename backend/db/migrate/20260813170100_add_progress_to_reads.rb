class AddProgressToReads < ActiveRecord::Migration[8.1]
  def change
    add_column :reads, :current_progress, :integer
    add_column :reads, :progress_type, :integer
  end
end
