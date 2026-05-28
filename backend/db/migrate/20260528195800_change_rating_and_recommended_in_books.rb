class ChangeRatingAndRecommendedInBooks < ActiveRecord::Migration[8.1]
  def up
    # Change rating to integer
    # PostgreSQL requires explicit conversion from string to integer
    change_column :books, :rating, :integer, using: 'rating::integer'

    # Change recommended to boolean
    # Handle existing 't'/'f' or other values
    change_column :books, :recommended, :boolean, using: "CASE WHEN recommended = 't' THEN true ELSE false END"
  end

  def down
    change_column :books, :rating, :string
    change_column :books, :recommended, :string
  end
end
