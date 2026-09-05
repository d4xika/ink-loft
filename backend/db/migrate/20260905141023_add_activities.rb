class AddActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.timestamps
      t.integer :action
      t.string :description
      t.references :user, null: false, foreign_key: true
    end
  end
end
