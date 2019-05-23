class CreateFollow < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :restaurant_id
    end
  end
end