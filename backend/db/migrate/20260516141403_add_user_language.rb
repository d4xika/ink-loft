class AddUserLanguage < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :language, :integer, default: 0, null: false
  end
end
