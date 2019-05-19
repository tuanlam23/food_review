class CreateFood < ActiveRecord::Migration[5.1]
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :restaurant_id
      t.string :picture
      t.integer :price
      t.timestamps null: false
    end
  end
end
