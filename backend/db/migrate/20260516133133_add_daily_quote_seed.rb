class AddDailyQuoteSeed < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :daily_quote_seed, :integer, default: 0, null: false
  end
end
