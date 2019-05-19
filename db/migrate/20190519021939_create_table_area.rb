class CreateTableArea < ActiveRecord::Migration[5.1]
  def change
    create_table :areas do |t|
      t.string :name
      t.integer :parent_id
      t.timestamps null: false
    end
  end
end
