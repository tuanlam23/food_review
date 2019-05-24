class AddColumnNumberStarToRestaurant < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :number_star, :integer, :null => false, :default => 0
  end
end
