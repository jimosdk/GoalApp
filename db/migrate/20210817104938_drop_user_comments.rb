class DropUserComments < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_comments
  end
end
