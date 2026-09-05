class AddPrivateOptionToQuote < ActiveRecord::Migration[8.1]
  def change
    add_column :quotes, :private, :boolean, default: false
  end
end
