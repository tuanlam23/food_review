class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.float :star
      t.timestamps
    end
  end
end
