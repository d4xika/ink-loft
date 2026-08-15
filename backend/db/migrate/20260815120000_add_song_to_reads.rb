class AddSongToReads < ActiveRecord::Migration[8.1]
  def change
    add_column :reads, :song, :string
  end
end
