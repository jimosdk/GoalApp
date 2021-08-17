class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :commenter_id
      t.references :commentable,polymorphic: true

      t.timestamps
    end
  end
end
