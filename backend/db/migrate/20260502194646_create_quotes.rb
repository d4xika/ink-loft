class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      t.timestamps
      t.string :content
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end
  end
end
