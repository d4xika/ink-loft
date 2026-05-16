class AddUserLanguage < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :language, :string, default: "en", null: false
  end
end
