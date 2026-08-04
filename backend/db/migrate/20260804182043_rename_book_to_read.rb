class RenameBookToRead < ActiveRecord::Migration[8.1]
  def change
    rename_table :books, :reads
    rename_column :quotes, :book_id, :read_id
  end
end
