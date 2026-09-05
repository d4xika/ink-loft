class AddQuotesShareWithFriendsToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :quotes_share_with_friends, :integer, array: true, default: []
  end
end
