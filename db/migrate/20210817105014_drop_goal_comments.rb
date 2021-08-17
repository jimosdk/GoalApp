class DropGoalComments < ActiveRecord::Migration[5.2]
  def change
    drop_table :goal_comments
  end
end
