class CreateRestaurant < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :description
      t.string :picture
      t.integer :category_id
      t.integer :area_id
      t.string :address
      t.string :open_time
      t.string :phone
      t.timestamps null: false
    end
  end
end
