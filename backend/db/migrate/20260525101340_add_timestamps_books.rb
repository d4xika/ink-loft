class AddTimestampsBooks < ActiveRecord::Migration[8.1]
  def change
    add_timestamps :books
  end
end
