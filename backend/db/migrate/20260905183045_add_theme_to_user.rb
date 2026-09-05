class AddThemeToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :theme, :integer, default: 0, null: false
  end
end
