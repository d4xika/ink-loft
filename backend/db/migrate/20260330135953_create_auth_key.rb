class CreateAuthKey < ActiveRecord::Migration[8.1]
  def change
    create_table :auth_keys do |t|
      t.timestamps
      t.string :key
      t.references :user, null: false, foreign_key: true
    end
  end
end
