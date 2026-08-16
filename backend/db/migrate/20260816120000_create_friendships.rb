class CreateFriendships < ActiveRecord::Migration[8.1]
  def change
    create_table :friendships do |t|
      t.references :user_one, null: false, foreign_key: { to_table: :users }
      t.references :user_two, null: false, foreign_key: { to_table: :users }
      t.references :requested_by, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :friendships, [ :user_one_id, :user_two_id ], unique: true
    add_check_constraint :friendships, "user_one_id < user_two_id", name: "friendships_ordered_users"
    add_check_constraint :friendships,
                         "requested_by_id = user_one_id OR requested_by_id = user_two_id",
                         name: "friendships_requester_is_member"
  end
end
