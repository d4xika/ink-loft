class AddBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, default: "Unknown"
      t.string :platform
      t.string :pairing
      t.string :cover_url
      t.integer :chapters
      t.integer :words
      t.integer :pages
      t.date :start_date
      t.date :end_date
      t.string :rating
      t.string :recommended
      t.string :notes
      t.string :link
      t.integer :reading_status, default: 0
      t.references :user, null: false, foreign_key: true
    end
  end
end
