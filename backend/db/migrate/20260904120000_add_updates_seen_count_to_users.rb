class AddUpdatesSeenCountToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :updates_seen_count, :integer
  end
end
