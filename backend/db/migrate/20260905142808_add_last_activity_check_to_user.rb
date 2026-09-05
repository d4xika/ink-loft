class AddLastActivityCheckToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :last_activity_check, :datetime
  end
end
