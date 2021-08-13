class AddDefaultValueToCompletedAndToPrivateInGoals < ActiveRecord::Migration[5.2]
  def change
    change_column_default :goals,:private,false
    change_column_default :goals,:completed,false
  end
end
