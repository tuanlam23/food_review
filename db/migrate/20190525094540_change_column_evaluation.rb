class ChangeColumnEvaluation < ActiveRecord::Migration[5.1]
  def change
    rename_column :evaluations, :user_id, :review_id
  end
end
