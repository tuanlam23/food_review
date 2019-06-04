class AddColunmUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :descriptions, :text
    add_column :users, :birthday, :date
  end
end
